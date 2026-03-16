import SwiftUI

struct StatsView: View {
    @EnvironmentObject var gameState: GameState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    StatCard(title: "游戏次数", value: "\(gameState.stats.totalSessions)", icon: "gamecontroller")
                    StatCard(title: "创建泡泡", value: "\(gameState.stats.totalBubblesCreated)", icon: "bubble.left")
                    StatCard(title: "总时长", value: "\(gameState.stats.totalSessionTime / 60)分钟", icon: "clock")
                }
                .padding()
            }
            .navigationTitle("统计")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Spacer()
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .monospaced))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        VStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}

extension GameState {
    var stats: (totalSessions: Int, totalBubblesCreated: Int, totalSessionTime: Int) {
        (totalSessions: 0, totalBubblesCreated: bubbles.count, totalSessionTime: sessionTime)
    }
}
