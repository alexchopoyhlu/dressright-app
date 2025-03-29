// AnimatedMeshGradient.swift

import SwiftUI

// A custom ViewModifier for the animated mesh gradient button
struct AnimatedMeshGradientButton: ViewModifier {
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    // Animation state variables
    @State private var animateGradient = false
    @State private var gradientPoints: [UnitPoint] = [
        UnitPoint(x: 0, y: 0),
        UnitPoint(x: 1, y: 1),
        UnitPoint(x: 0, y: 1),
        UnitPoint(x: 1, y: 0)
    ]
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: width, height: height)
            .background(
                ZStack {
                    // Multiple overlapping gradients to create mesh effect
                    LinearGradient(
                        colors: [
                            Color(red: 0.8, green: 0.2, blue: 0.9),
                            Color(red: 0.3, green: 0.6, blue: 0.6),
                            Color(red: 0.2, green: 0.8, blue: 0.8)
                        ],
                        startPoint: animateGradient ? gradientPoints[0] : gradientPoints[1],
                        endPoint: animateGradient ? gradientPoints[1] : gradientPoints[0]
                    )
                    
                    LinearGradient(
                        colors: [
                            Color(red: 0.4, green: 0.2, blue: 0.9).opacity(0.5),
                            Color(red: 0.2, green: 0.3, blue: 0.7).opacity(0.5),
                            Color(red: 0.3, green: 0.1, blue: 0.6).opacity(0.5)
                        ],
                        startPoint: animateGradient ? gradientPoints[2] : gradientPoints[3],
                        endPoint: animateGradient ? gradientPoints[3] : gradientPoints[2]
                    )
                    
                    // Add a subtle radial gradient for depth
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.2),
                            Color.clear
                        ],
                        center: animateGradient ? .topTrailing : .bottomLeading,
                        startRadius: 0,
                        endRadius: width * 0.8
                    )
                }
            )
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .onAppear {
                // Start the animation when the button appears
                withAnimation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
                
                // Animate gradient points for more fluid movement
                withAnimation(Animation.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                    gradientPoints = [
                        UnitPoint(x: 1, y: 1),
                        UnitPoint(x: 0, y: 0),
                        UnitPoint(x: 1, y: 0),
                        UnitPoint(x: 0, y: 1)
                    ]
                }
            }
    }
}
