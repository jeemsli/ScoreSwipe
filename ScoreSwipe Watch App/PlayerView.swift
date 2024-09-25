import SwiftUI

struct PlayerView: View {
    var player: Player
    
    init(player: Player) {
        self.player = player
    }
    
    var body: some View {
        playerView(player)
    }
    
    private func playerView(_ player: Player) -> some View {
        let backgroundColor = player.isOpponent ? Color.red : Color.blue
        
        return ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 40, height: 40)
                .padding()
            
            Text(player.name)
                .font(.footnote)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
            
        }
        .opacity(player.isServing ? 1 : 0.3)
    }
}

#Preview {
    var player = Player(name: "Me", isOpponent: false, side: "Right", isServing: true)
    
    return PlayerView(player: player)
}
