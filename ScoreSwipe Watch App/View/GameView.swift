import SwiftUI
import WatchKit

struct GameView: View {
    var gameSettingsViewModel: GameSettingsViewModel
    var gameViewModel: GameViewModel
    
    @State private var showGameFinishedAlert: Bool = false
    @State private var navigateToNewGame: Bool = false
    
    init(gameSettingsViewModel: GameSettingsViewModel) {
        self.gameSettingsViewModel = gameSettingsViewModel
        self.gameViewModel = GameViewModel(settings: gameSettingsViewModel.gameSettings)
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
                    ScoreView(viewModel: gameViewModel)
                    
                    // Opponent 1
                    VStack {
                        HStack {
                            if gameViewModel.opponentOne?.side == "Right" {
                                PlayerView(player: gameViewModel.opponentOne!)
                                Spacer()
                            } else {
                                Spacer()
                                PlayerView(player: gameViewModel.opponentOne!)
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: gameViewModel.opponentOne?.side)
                    
                    // Opponent 2
                    VStack {
                        HStack {
                            if gameViewModel.opponentTwo?.side == "Left" {
                                Spacer()
                                PlayerView(player: gameViewModel.opponentTwo!)
                            } else {
                                PlayerView(player: gameViewModel.opponentTwo!)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: gameViewModel.opponentTwo?.side)
                    
                    // User
                    VStack {
                        Spacer()
                        HStack {
                            if gameViewModel.user?.side == "Left" {
                                PlayerView(player: gameViewModel.user!)
                                Spacer()
                            } else {
                                Spacer()
                                PlayerView(player: gameViewModel.user!)
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: gameViewModel.user?.side)
                    
                    // Partner
                    VStack {
                        Spacer()
                        HStack {
                            if gameViewModel.partner?.side == "Right" {
                                Spacer()
                                PlayerView(player: gameViewModel.partner!)
                            } else {
                                PlayerView(player: gameViewModel.partner!)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .animation(.easeInOut, value: gameViewModel.partner?.side)
                }
                .background(Color.black)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showGameFinishedAlert, content: alertContent)
            }
        }
        .navigationDestination(isPresented: $navigateToNewGame) {
            GameSettingsView(gameSettingsViewModel: gameSettingsViewModel)
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
            gameViewModel.updateOpponentScore()
        } else if value.translation.height > threshold {
            playHapticFeedback(for: "point")
            gameViewModel.updateOurScore()
        } else if value.translation.width < -threshold {
            playHapticFeedback(for: "undo")
            gameViewModel.undo()
        }
        
        if gameViewModel.gameFinished {
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
        let winner = gameViewModel.ourScore >= gameViewModel.opponentScore
        let title = winner ? "Your team wins!" : "Opponent team wins!"
        let scoreMessage = winner ? "Score: \(gameViewModel.ourScore) - \(gameViewModel.opponentScore)" : "Score: \(gameViewModel.opponentScore) - \(gameViewModel.ourScore)"
        
        return Alert(
            title: Text(title),
            message: Text(scoreMessage),
            primaryButton: .default(Text("Undo"), action: {
                gameViewModel.undo()
            }),
            secondaryButton: .default(Text("New Game"), action: resetGame)
        )
    }
    
    private func resetGame() {
        navigateToNewGame = true
    }
}

#Preview {
    let gameSettingsViewModel = GameSettingsViewModel()
    
    return GameView(gameSettingsViewModel: gameSettingsViewModel)
}
