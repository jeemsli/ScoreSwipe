import SwiftUI

struct ScoreView: View {
    var match: Match
    
    init(match: Match) {
        self.match = match
    }
    
    var body: some View {
        HStack {
            Spacer()
            scoreText(match.servingTeam == "Us" ? match.ourScore : match.opponentScore, color: .blue)
            scoreText(match.servingTeam == "Us" ? match.opponentScore : match.ourScore, color: .red)
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
    var matchSettings = MatchSettings()
    var undoManager = UndoManager()
    var match = Match(settings: matchSettings, undoManager: undoManager)
    
    return ScoreView(match: match)
}
