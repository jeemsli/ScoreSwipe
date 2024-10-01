import SwiftUI

struct ScoreView: View {
    var gameViewModel: GameViewModel
    
    init(viewModel: GameViewModel) {
        self.gameViewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Spacer()
            if gameViewModel.servingTeam == "Us" {
                scoreText(gameViewModel.ourScore, color: .blue)
                scoreText(gameViewModel.opponentScore, color: .red)
            } else {
                scoreText(gameViewModel.opponentScore, color: .red)
                scoreText(gameViewModel.ourScore, color: .blue)
            }
            scoreText(gameViewModel.position, color: .white)
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
    let viewModel = GameViewModel(settings: gameSettings)
    
    ScoreView(viewModel: viewModel)
}
