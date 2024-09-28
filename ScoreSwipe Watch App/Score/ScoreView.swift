import SwiftUI

struct ScoreView: View {
    var match: Match
    
    init(match: Match) {
        self.match = match
    }
    
    var body: some View {
        HStack {
            Spacer()
            if match.servingTeam == "Us" {
                scoreText(match.ourScore, color: .blue)
                scoreText(match.opponentScore, color: .red)
            } else {
                scoreText(match.opponentScore, color: .red)
                scoreText(match.ourScore, color: .blue)
            }
            scoreText(match.position, color: .white)
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
    let matchSettings = MatchSettings()
    let undoManager = UndoManager()
    let match = Match(settings: matchSettings, undoManager: undoManager)
    
    return ScoreView(match: match)
}
