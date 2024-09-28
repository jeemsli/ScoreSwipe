import SwiftUI

struct GameSettingsView: View {
    var gameSettings: GameSettings
    
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
                            
                        NavigationLink(destination: GameView(gameSettings: gameSettings)) {
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
            settingButton(title: "Doubles", isSelected: gameSettings.isDoubles) {
                gameSettings.isDoubles = true
            }
        }
    }
    
    private var gamePointButtons: some View {
        HStack {
            ForEach(gameSettings.gamePoints, id: \.self) { points in
                settingButton(title: "\(points)", isSelected: gameSettings.gamePoint == points) {
                    gameSettings.gamePoint = points
                }
            }
        }
    }
    
    private var servingTeamButtons: some View {
        HStack {
            settingButton(title: "Us", isSelected: gameSettings.servingTeam == "Us") {
                gameSettings.servingTeam = "Us"
            }
            settingButton(title: "Them", isSelected: gameSettings.servingTeam == "Them") {
                gameSettings.servingTeam = "Them"
            }
        }
    }
    
    private var startingSideButtons: some View {
        HStack {
            settingButton(title: "Left", isSelected: gameSettings.startingSide == "Left") {
                gameSettings.startingSide = "Left"
            }
            settingButton(title: "Right", isSelected: gameSettings.startingSide == "Right") {
                gameSettings.startingSide = "Right"
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
        let sampleSettings = GameSettings()
        GameSettingsView(gameSettings: sampleSettings)
    }
}
