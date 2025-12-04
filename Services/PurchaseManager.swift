//
//  PurchaseManager.swift
//  DailyGlow
//
//  Full StoreKit 2 implementation for in-app purchases and subscriptions
//  This is where the money comes in! 💰🚀
//

import StoreKit
import SwiftUI

// MARK: - Product Identifiers
enum ProductID: String, CaseIterable {
    case weekly = "com.dailyglow.premium.weekly"
    case monthly = "com.dailyglow.premium.monthly"
    case yearly = "com.dailyglow.premium.yearly"
    case lifetime = "com.dailyglow.premium.lifetime"
    
    var isSubscription: Bool {
        switch self {
        case .lifetime:
            return false
        default:
            return true
        }
    }
}

// MARK: - Purchase Error
enum PurchaseError: LocalizedError {
    case productNotFound
    case purchaseFailed
    case purchaseCancelled
    case purchasePending
    case verificationFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "Product not found. Please try again later."
        case .purchaseFailed:
            return "Purchase failed. Please try again."
        case .purchaseCancelled:
            return "Purchase was cancelled."
        case .purchasePending:
            return "Purchase is pending approval."
        case .verificationFailed:
            return "Could not verify your purchase. Please contact support."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - Purchase Manager
@MainActor
class PurchaseManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isLoading = false
    @Published private(set) var isPremium = false
    @Published private(set) var subscriptionStatus: SubscriptionStatus = .notSubscribed
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Private Properties
    private var updateListenerTask: Task<Void, Error>?
    private let userDefaults = UserDefaults.standard
    private let premiumKey = "isPremium"
    
    // MARK: - Subscription Status
    enum SubscriptionStatus {
        case notSubscribed
        case subscribed(expirationDate: Date?, productID: String)
        case expired
        case inGracePeriod
        case inBillingRetry
        
        var isActive: Bool {
            switch self {
            case .subscribed, .inGracePeriod, .inBillingRetry:
                return true
            default:
                return false
            }
        }
    }
    
    // MARK: - Singleton
    static let shared = PurchaseManager()
    
    // MARK: - Initialization
    init() {
        // Load cached premium status
        isPremium = userDefaults.bool(forKey: premiumKey)
        
        // Start listening for transactions
        updateListenerTask = listenForTransactions()
        
        // Load products and check status
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Load Products
    func loadProducts() async {
        isLoading = true
        
        do {
            let productIDs = ProductID.allCases.map { $0.rawValue }
            products = try await Product.products(for: productIDs)
            
            // Sort products by price
            products.sort { $0.price < $1.price }
            
            isLoading = false
        } catch {
            print("Failed to load products: \(error)")
            isLoading = false
            errorMessage = "Failed to load products. Please check your internet connection."
            showError = true
        }
    }
    
    // MARK: - Purchase Product
    func purchase(_ productID: ProductID) async throws {
        guard let product = products.first(where: { $0.id == productID.rawValue }) else {
            throw PurchaseError.productNotFound
        }
        
        return try await purchase(product)
    }
    
    func purchase(_ product: Product) async throws {
        isLoading = true
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Check verification
                let transaction = try checkVerified(verification)
                
                // Update purchased products
                await updatePurchasedProducts()
                
                // Finish the transaction
                await transaction.finish()
                
                // Haptic feedback
                HapticManager.shared.notification(.success)
                
                isLoading = false
                
            case .userCancelled:
                isLoading = false
                throw PurchaseError.purchaseCancelled
                
            case .pending:
                isLoading = false
                throw PurchaseError.purchasePending
                
            @unknown default:
                isLoading = false
                throw PurchaseError.unknown
            }
        } catch {
            isLoading = false
            throw error
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async throws {
        isLoading = true
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            isLoading = false
            
            if isPremium {
                HapticManager.shared.notification(.success)
            } else {
                errorMessage = "No previous purchases found."
                showError = true
            }
        } catch {
            isLoading = false
            errorMessage = "Failed to restore purchases. Please try again."
            showError = true
            throw error
        }
    }
    
    // MARK: - Update Purchased Products
    func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []
        var hasActiveSubscription = false
        var hasLifetime = false
        
        // Check current entitlements
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            purchasedIDs.insert(transaction.productID)
            
            // Check if it's the lifetime purchase
            if transaction.productID == ProductID.lifetime.rawValue {
                hasLifetime = true
            }
            
            // Check subscription status
            if transaction.productType == .autoRenewable {
                if let expirationDate = transaction.expirationDate {
                    if expirationDate > Date() {
                        hasActiveSubscription = true
                        subscriptionStatus = .subscribed(
                            expirationDate: expirationDate,
                            productID: transaction.productID
                        )
                    }
                }
            }
        }
        
        purchasedProductIDs = purchasedIDs
        isPremium = hasActiveSubscription || hasLifetime
        
        // Cache premium status
        userDefaults.set(isPremium, forKey: premiumKey)
        
        // Update StorageManager
        StorageManager.shared.updatePremiumStatus(isPremium: isPremium)
        
        // Update subscription status if no active subscription
        if !hasActiveSubscription && !hasLifetime {
            subscriptionStatus = .notSubscribed
        }
    }
    
    // MARK: - Transaction Listener
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Verification
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Get Product
    func product(for productID: ProductID) -> Product? {
        products.first { $0.id == productID.rawValue }
    }
    
    // MARK: - Format Price
    func formattedPrice(for productID: ProductID) -> String {
        guard let product = product(for: productID) else {
            // Fallback prices
            switch productID {
            case .weekly: return "$1.99"
            case .monthly: return "$4.99"
            case .yearly: return "$39.99"
            case .lifetime: return "$99.99"
            }
        }
        return product.displayPrice
    }
    
    // MARK: - Subscription Info
    func subscriptionPeriod(for productID: ProductID) -> String {
        guard let product = product(for: productID),
              let subscription = product.subscription else {
            switch productID {
            case .weekly: return "/week"
            case .monthly: return "/month"
            case .yearly: return "/year"
            case .lifetime: return "one time"
            }
        }
        
        let unit = subscription.subscriptionPeriod.unit
        let value = subscription.subscriptionPeriod.value
        
        switch unit {
        case .day:
            return value == 7 ? "/week" : "/\(value) days"
        case .week:
            return value == 1 ? "/week" : "/\(value) weeks"
        case .month:
            return value == 1 ? "/month" : "/\(value) months"
        case .year:
            return value == 1 ? "/year" : "/\(value) years"
        @unknown default:
            return ""
        }
    }
    
    // MARK: - Trial Info
    func hasFreeTrial(for productID: ProductID) -> Bool {
        guard let product = product(for: productID),
              let subscription = product.subscription,
              let introOffer = subscription.introductoryOffer else {
            return false
        }
        return introOffer.paymentMode == .freeTrial
    }
    
    func freeTrialDuration(for productID: ProductID) -> String? {
        guard let product = product(for: productID),
              let subscription = product.subscription,
              let introOffer = subscription.introductoryOffer,
              introOffer.paymentMode == .freeTrial else {
            return nil
        }
        
        let period = introOffer.period
        switch period.unit {
        case .day:
            return "\(period.value)-day"
        case .week:
            return "\(period.value)-week"
        case .month:
            return "\(period.value)-month"
        case .year:
            return "\(period.value)-year"
        @unknown default:
            return nil
        }
    }
}

// MARK: - Premium Access Check Extension
extension PurchaseManager {
    
    /// Check if user can access premium feature
    func canAccessPremiumFeature() -> Bool {
        return isPremium
    }
    
    /// Request premium access - shows paywall if not premium
    func requestPremiumAccess(from presenter: Any? = nil) -> Bool {
        if isPremium {
            return true
        }
        
        // Post notification to show paywall
        NotificationCenter.default.post(name: Notification.Name("ShowPaywall"), object: nil)
        return false
    }
}

