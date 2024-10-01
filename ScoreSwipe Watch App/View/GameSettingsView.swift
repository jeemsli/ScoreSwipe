import SwiftUI

struct GameSettingsView: View {
    var gameSettingsViewModel: GameSettingsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scroll in
                ScrollView {
                    VStack {
                        headerView("Mode")
                            .id("top")
                        modeButtons
                        
                        headerView("Game Point")
                        gamePointButtons
                        
                        headerView("First Serve")
                        servingTeamButtons
                        
                        headerView("Starting Side")
                        startingSideButtons
                        
                        NavigationLink(destination: GameView(gameSettingsViewModel: gameSettingsViewModel)) {
                            Text("Start Game")
                                .foregroundStyle(.green)
                        }
                        .padding(.top)
                    }
                    .onAppear {
                        scroll.scrollTo("top", anchor: .top)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func headerView(_ title: String) -> some View {
        Text(title)
            .font(.headline)
    }
    
    private var modeButtons: some View {
        HStack {
            settingButton(title: "Doubles", isSelected: gameSettingsViewModel.gameSettings.isDoubles) {
                gameSettingsViewModel.selectMode(isDoubles: true)
            }
        }
    }
    
    private var gamePointButtons: some View {
        HStack {
            ForEach(gameSettingsViewModel.gameSettings.gamePoints, id: \.self) { points in
                settingButton(title: "\(points)", isSelected: gameSettingsViewModel.gameSettings.gamePoint == points) {
                    gameSettingsViewModel.selectGamePoint(points)
                }
            }
        }
    }
    
    private var servingTeamButtons: some View {
        HStack {
            settingButton(title: "Us", isSelected: gameSettingsViewModel.gameSettings.servingTeam == "Us") {
                gameSettingsViewModel.selectServingTeam("Us")
            }
            settingButton(title: "Them", isSelected: gameSettingsViewModel.gameSettings.servingTeam == "Them") {
                gameSettingsViewModel.selectServingTeam("Them")
            }
        }
    }
    
    private var startingSideButtons: some View {
        HStack {
            settingButton(title: "Left", isSelected: gameSettingsViewModel.gameSettings.startingSide == "Left") {
                gameSettingsViewModel.selectStartingSide("Left")
            }
            settingButton(title: "Right", isSelected: gameSettingsViewModel.gameSettings.startingSide == "Right") {
                gameSettingsViewModel.selectStartingSide("Right")
            }
        }
    }
    
    private func settingButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .background(isSelected ? Color.blue : Color.black)
            .clipShape(.capsule)
            .opacity(isSelected ? 1 : 0.5)
            .animation(.snappy, value: isSelected)
    }
}

struct GameSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GameSettingsViewModel()
        GameSettingsView(gameSettingsViewModel: viewModel)
    }
}
