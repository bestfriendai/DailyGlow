import SwiftUI

// MARK: - Custom Shapes

// Wave Shape for backgrounds
struct WaveShape: Shape {
    var offset: CGFloat
    var amplitude: CGFloat
    var frequency: CGFloat
    
    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * frequency * .pi * 2 + offset)
            let y = amplitude * sine + height * 0.5
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        
        return path
    }
}

// Blob Shape for organic backgrounds
struct BlobShape: Shape {
    var animatableData: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let centerX = width / 2
        let centerY = height / 2
        let radius = min(width, height) / 2
        
        var path = Path()
        
        let points = 6
        let angleStep = .pi * 2 / Double(points)
        
        for i in 0..<points {
            let angle = angleStep * Double(i) + Double(animatableData)
            let variation = sin(angle * 3 + Double(animatableData)) * 0.2 + 1
            let r = radius * variation
            let x = centerX + CGFloat(cos(angle)) * r
            let y = centerY + CGFloat(sin(angle)) * r
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                let prevAngle = angleStep * Double(i - 1) + Double(animatableData)
                
                let controlAngle = (prevAngle + angle) / 2
                let controlR = radius * 1.1
                let controlX = centerX + CGFloat(cos(controlAngle)) * controlR
                let controlY = centerY + CGFloat(sin(controlAngle)) * controlR
                
                path.addQuadCurve(to: CGPoint(x: x, y: y), control: CGPoint(x: controlX, y: controlY))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// Rounded Star Shape
struct StarShape: Shape {
    let points: Int
    let innerRadius: CGFloat
    let outerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let angleStep = .pi / Double(points)
        
        var path = Path()
        
        for i in 0..<(points * 2) {
            let angle = angleStep * Double(i) - .pi / 2
            let radius = i % 2 == 0 ? outerRadius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// Hexagon Shape
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        
        for i in 0..<6 {
            let angle = .pi / 3 * Double(i) - .pi / 2
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        WaveShape(offset: 0, amplitude: 20, frequency: 2)
            .fill(Color.glowGold)
            .frame(height: 100)
        
        BlobShape(animatableData: 0)
            .fill(Color.glowPurple)
            .frame(width: 150, height: 150)
        
        StarShape(points: 5, innerRadius: 30, outerRadius: 60)
            .fill(Color.glowCoral)
            .frame(width: 120, height: 120)
        
        HexagonShape()
            .fill(Color.glowTeal)
            .frame(width: 100, height: 100)
    }
    .padding()
    .background(Color.backgroundDark)
}
