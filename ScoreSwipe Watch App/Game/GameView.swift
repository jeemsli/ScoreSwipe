import SwiftUI
import WatchKit

struct GameView: View {
    @Environment(\.undoManager) var undoManager
    
    var gameSettings: GameSettings
    var game: Game
    
    @State private var showGameFinishedAlert: Bool = false
    @State private var navigateToNewGame: Bool = false
    
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        self.game = Game(settings: gameSettings)
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
                    ScoreView(game: game)
                    
                    // Opponent 1
                    VStack {
                        HStack {
                            if game.opponentOne?.side == "Right" {
                                PlayerView(player: game.opponentOne!)
                                Spacer()
                            } else {
                                Spacer()
                                PlayerView(player: game.opponentOne!)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: game.opponentOne?.side)
                    
                    // Opponent 2
                    VStack {
                        HStack {
                            if game.opponentTwo?.side == "Left" {
                                Spacer()
                                PlayerView(player: game.opponentTwo!)
                            } else {
                                PlayerView(player: game.opponentTwo!)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: game.opponentTwo?.side)
                    
                    // User
                    VStack {
                        Spacer()
                        HStack {
                            if game.user?.side == "Left" {
                                PlayerView(player: game.user!)
                                Spacer()
                            } else {
                                Spacer()
                                PlayerView(player: game.user!)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: game.user?.side)
                    
                    // Partner
                    VStack {
                        Spacer()
                        HStack {
                            if game.partner?.side == "Right" {
                                Spacer()
                                PlayerView(player: game.partner!)
                            } else {
                                PlayerView(player: game.partner!)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: game.partner?.side)
                }
                .background(Color.black)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showGameFinishedAlert, content: alertContent)
            }
            
            .navigationDestination(isPresented: $navigateToNewGame) {
                GameSettingsView(gameSettings: gameSettings)
            }
        }
        .onAppear {
            game.undoManager = undoManager
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
            playHapticFeedback(for: "point")
            game.updateOpponentScore()
        } else if value.translation.height > threshold {
            playHapticFeedback(for: "point")
            game.updateOurScore()
        } else if value.translation.width < -threshold {
            playHapticFeedback(for: "undo")
            undoManager?.undo()
        }
        
        if game.checkGameFinished() {
            showGameFinishedAlert = true
        }
    }
    
    func playHapticFeedback(for swipeType: String) {
        let device = WKInterfaceDevice.current()
        
        switch swipeType {
            case "point":
                device.play(.click)
            case "undo":
                device.play(.start)
            default:
                device.play(.click)
        }
    }
    
    private func alertContent() -> Alert {
        let winner = game.ourScore >= game.opponentScore
        let title = winner ? "Your team wins!" : "Opponent team wins!"
        let scoreMessage = winner ? "Score: \(game.ourScore) - \(game.opponentScore)" : "Score: \(game.opponentScore) - \(game.ourScore)"
        
        return Alert(
            title: Text(title),
            message: Text(scoreMessage),
            primaryButton: .default(Text("Undo"), action: {
                undoManager?.undo()
            }),
            secondaryButton: .default(Text("New Game"), action: resetGame)
        )
    }
    
    private func resetGame() {
        gameSettings.reset()
        game.reset(settings: gameSettings)
        undoManager?.removeAllActions()
        navigateToNewGame = true
    }
}

#Preview {
    let gameSettings = GameSettings()
    
    return GameView(gameSettings: gameSettings)
}
