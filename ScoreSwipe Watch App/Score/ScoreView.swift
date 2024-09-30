import SwiftUI

struct ScoreView: View {
    var game: Game
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        HStack {
            Spacer()
            if game.servingTeam == "Us" {
                scoreText(game.ourScore, color: .blue)
                scoreText(game.opponentScore, color: .red)
            } else {
                scoreText(game.opponentScore, color: .red)
                scoreText(game.ourScore, color: .blue)
            }
            scoreText(game.position, color: .white)
            Spacer()
        }
    }
    
    private func scoreText(_ score: Int, color: Color) -> some View {
        Text("\(score)")
            .font(.largeTitle)
            .bold()
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    let gameSettings = GameSettings()
    let game = Game(settings: gameSettings)
    
    return ScoreView(game: game)
}
