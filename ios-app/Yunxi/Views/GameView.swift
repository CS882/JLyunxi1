import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameState: GameState
    @State private var showTapAnimation = false
    @State private var tapLocation: CGPoint = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(gameState.bubbles) { bubble in
                    BubbleView(bubble: bubble)
                        .position(x: bubble.position.x, y: bubble.position.y)
                        .scaleEffect(bubble.scale)
                        .opacity(bubble.opacity)
                }
                
                if showTapAnimation {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 60, height: 60)
                        .position(tapLocation)
                        .scaleEffect(1.5)
                        .opacity(0)
                        .animation(.easeOut(duration: 0.4), value: tapLocation)
                }
                
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        TapGesture()
                            .onEnded { value in
                                tapLocation = value.location
                                showTapAnimation = true
                                gameState.createBubble(at: value.location, in: geometry.size)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showTapAnimation = false
                                }
                            }
                    )
            }
        }
        .onAppear { gameState.startSession() }
        .onDisappear { gameState.endSession() }
    }
}

struct BubbleView: View {
    let bubble: Bubble
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            bubble.color.opacity(0.3),
                            bubble.color.opacity(0.1),
                            Color.clear
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: bubble.size
                    )
                )
                .frame(width: bubble.size, height: bubble.size)
                .blur(radius: 2)
            
            Circle()
                .fill(Color.white.opacity(0.4))
                .frame(width: bubble.size * 0.3, height: bubble.size * 0.2)
                .offset(x: -bubble.size * 0.15, y: -bubble.size * 0.2)
        }
    }
}
