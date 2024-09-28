import SwiftUI

struct MatchView: View {
    @Environment(\.undoManager) var undoManager
    
    var matchSettings: MatchSettings
    var match: Match
    
    @State private var showMatchFinishedAlert: Bool = false
    @State private var navigateToNewGame: Bool = false
    
    init(matchSettings: MatchSettings) {
        self.matchSettings = matchSettings
        self.match = Match(settings: matchSettings)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    // Swipe gesture applied
                    Color.clear
                        .contentShape(.rect)
                        .gesture(dragGesture)
                    
                    // Score in the center
                    ScoreView(match: match)
                    
                    // Opponent 1
                    VStack {
                        HStack {
                            if match.opponentOne?.side == "Right" {
                                PlayerView(player: match.opponentOne!)
                                Spacer()
                            } else {
                                Spacer()
                                PlayerView(player: match.opponentOne!)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: match.opponentOne?.side)
                    
                    // Opponent 2
                    VStack {
                        HStack {
                            if match.opponentTwo?.side == "Left" {
                                Spacer()
                                PlayerView(player: match.opponentTwo!)
                            } else {
                                PlayerView(player: match.opponentTwo!)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: match.opponentTwo?.side)
                    
                    // User
                    VStack {
                        Spacer()
                        HStack {
                            if match.user?.side == "Left" {
                                PlayerView(player: match.user!)
                                Spacer()
                            } else {
                                Spacer()
                                PlayerView(player: match.user!)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: match.user?.side)
                    
                    // Partner
                    VStack {
                        Spacer()
                        HStack {
                            if match.partner?.side == "Right" {
                                Spacer()
                                PlayerView(player: match.partner!)
                            } else {
                                PlayerView(player: match.partner!)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: match.partner?.side)
                }
                .background(Color.black)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showMatchFinishedAlert, content: alertContent)
            }
            
            .navigationDestination(isPresented: $navigateToNewGame) {
                MatchSettingsView(matchSettings: matchSettings)
            }
        }
        .onAppear {
            match.undoManager = undoManager
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                withAnimation(.smooth) {
                    handleSwipe(value: value)
                }
            }
    }
    
    private func handleSwipe(value: DragGesture.Value) {
        let threshold: CGFloat = 50.0
        
        if value.translation.height < -threshold {
            match.updateOpponentScore()
        } else if value.translation.height > threshold {
            match.updateOurScore()
        } else if value.translation.width < -threshold {
            undoManager?.undo()
        }
        
        if match.checkMatchFinished() {
            showMatchFinishedAlert = true
        }
    }
    
    private func alertContent() -> Alert {
        let winner = match.ourScore >= match.opponentScore
        let title = winner ? "Your team wins!" : "Opponent team wins!"
        let scoreMessage = winner ? "Score: \(match.ourScore) - \(match.opponentScore)" : "Score: \(match.opponentScore) - \(match.ourScore)"
        
        return Alert(
            title: Text(title),
            message: Text(scoreMessage),
            primaryButton: .default(Text("Undo"), action: {
                undoManager?.undo()
            }),
            secondaryButton: .default(Text("New Match"), action: resetMatch)
        )
    }
    
    private func resetMatch() {
        matchSettings.reset()
        match.reset(settings: matchSettings)
        undoManager?.removeAllActions()
        navigateToNewGame = true
    }
}

#Preview {
    var matchSettings = MatchSettings()
    
    return MatchView(matchSettings: matchSettings)
}
