import SwiftUI

struct MatchView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    // Swipe gesture applied to entire screen
                    Color.clear
                        .contentShape(.rect)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    withAnimation(.smooth) {
                                        let threshold = 50.0
                                        
                                        // Swipe up to increase opponent score
                                        if value.translation.height < -threshold {
                                            match.updateOpponentScore()
                                            
                                        }
                                        // Swipe down to increase our score
                                        else if value.translation.height > threshold {
                                            match.updateOurScore()
                                            
                                        }
                                        
                                        else if value.translation.width < -threshold {
                                            undoManager?.undo()
                                        }
                                        
                                        if match.checkMatchFinished() {
                                            showMatchFinishedAlert = true
                                        }
                                    }
                                }
                        )
                    
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
            }
            .background(Color.black)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showMatchFinishedAlert) {
                if (match.ourScore >= match.opponentScore) {
                    return Alert(
                        title: Text("Your team wins!"),
                        message: Text("Score: \(match.ourScore) - \(match.opponentScore)"),
                        primaryButton: .default(Text("Undo"), action: {
                            // Undo last point
                            undoManager?.undo()
                        }),
                        secondaryButton: .default(Text("New Match"), action: {
                            presentationMode.wrappedValue.dismiss()
                            matchSettings.reset()
                            match.reset(settings: matchSettings)
                            navigateToNewGame = true
                        })
                    )
                } else {
                    return Alert(
                        title: Text("Opponent team wins!"),
                        message: Text("Score: \(match.opponentScore) - \(match.ourScore)"),
                        primaryButton: .default(Text("Undo"), action: {
                            // Undo last point
                            undoManager?.undo()
                            
                        }),
                        secondaryButton: .default(Text("New Match"), action: {
                            presentationMode.wrappedValue.dismiss()
                            matchSettings.reset()
                            match.reset(settings: matchSettings)
                            navigateToNewGame = true
                        })
                    )
                }
            }
            .navigationDestination(isPresented: $navigateToNewGame) {
                MatchSettingsView(matchSettings: matchSettings)
            }
        }
        .onAppear {
            match.undoManager = undoManager
        }
    }
}

#Preview {
    var matchSettings = MatchSettings()
    
    return MatchView(matchSettings: matchSettings)
}
