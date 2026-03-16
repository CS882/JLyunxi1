import SwiftUI

@main
struct YunxiApp: App {
    @StateObject private var gameState = GameState.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameState)
        }
    }
}
