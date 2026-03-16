import SwiftUI

struct Bubble: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var scale: CGFloat
    var opacity: Double
    
    init(id: UUID = UUID(), position: CGPoint, size: CGFloat, color: Color, scale: CGFloat = 1.0, opacity: Double = 1.0) {
        self.id = id
        self.position = position
        self.size = size
        self.color = color
        self.scale = scale
        self.opacity = opacity
    }
    
    static let colors: [Color] = [
        Color(red: 0.7, green: 0.85, blue: 0.95),
        Color(red: 0.85, green: 0.9, blue: 0.95),
        Color(red: 0.9, green: 0.85, blue: 0.95),
        Color(red: 0.85, green: 0.95, blue: 0.9)
    ]
}

class GameState: ObservableObject {
    static let shared = GameState()
    
    @Published var bubbles: [Bubble] = []
    @Published var sessionTime: Int = 0
    @Published var isSessionActive: Bool = false
    
    private var gameTimer: Timer?
    private var sessionTimer: Timer?
    
    private init() {}
    
    func startSession() {
        guard !isSessionActive else { return }
        isSessionActive = true
        sessionTime = 0
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60, repeats: true) { [weak self] _ in
            self?.updateGameLoop()
        }
        
        sessionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.sessionTime += 1
        }
    }
    
    func endSession() {
        isSessionActive = false
        gameTimer?.invalidate()
        sessionTimer?.invalidate()
    }
    
    func createBubble(at location: CGPoint, in size: CGSize) {
        guard bubbles.count < 50 else { return }
        
        let bubbleSize = CGFloat.random(in: 30...60)
        let color = Bubble.colors.randomElement() ?? .cyan
        
        let bubble = Bubble(
            position: location,
            size: bubbleSize,
            color: color,
            scale: 0.5,
            opacity: 0.8
        )
        
        withAnimation(.spring(response: 0.3)) {
            bubbles.append(bubble)
        }
    }
    
    private func updateGameLoop() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var updated: [Bubble] = []
            for var bubble in self.bubbles {
                bubble.position.y -= 0.5
                bubble.position.x += sin(Double(bubble.position.y) * 0.1) * 0.2
                
                if bubble.scale < 1.0 { bubble.scale += 0.02 }
                
                let age = Date().timeIntervalSince(bubble.createdAt ?? Date())
                if age > 8.0 {
                    bubble.opacity -= 0.05
                }
                
                if bubble.opacity > 0 && bubble.position.y > -bubble.size {
                    updated.append(bubble)
                }
            }
            self.bubbles = updated
        }
    }
}

extension Bubble {
    var createdAt: Date? { nil }
}
