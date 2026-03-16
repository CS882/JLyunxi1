import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameState: GameState
    @State private var showingSettings = false
    @State private var showingStats = false
    
    var body: some View {
        ZStack {
            BackgroundGradientView()
            
            VStack(spacing: 0) {
                HeaderView(
                    sessionTime: gameState.sessionTime,
                    bubblesCount: gameState.bubbles.count,
                    onSettingsTap: { showingSettings = true },
                    onStatsTap: { showingStats = true }
                )
                
                GameView()
                    .flexible()
                
                FooterView()
            }
            .padding()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingStats) {
            StatsView()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.94, green: 0.96, blue: 0.98),
                Color(red: 0.88, green: 0.91, blue: 0.94)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct HeaderView: View {
    let sessionTime: Int
    let bubblesCount: Int
    let onSettingsTap: () -> Void
    let onStatsTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("云息")
                    .font(.system(size: 20, weight: .medium))
                Text(timeString(from: sessionTime))
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                GlassCardView {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 12))
                        Text("\(bubblesCount)")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    }
                    .foregroundColor(.accentColor)
                }
                .frame(width: 70, height: 36)
                
                Button(action: onStatsTap) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                
                Button(action: onSettingsTap) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct FooterView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("轻点屏幕，呼出一缕云息")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.secondary)
            Text("配合呼吸，放松片刻")
                .font(.system(size: 12, weight: .ultraLight))
                .foregroundColor(.tertiary)
        }
        .padding(.vertical, 12)
    }
}

struct GlassCardView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    
    var body: some View {
        content
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(RoundedRectangle(cornerRadius: 18).fill(.ultraThinMaterial))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.white.opacity(0.2), lineWidth: 1))
    }
}
