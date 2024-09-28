import SwiftUI

struct MatchSettingsView: View {
    var matchSettings: MatchSettings
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scroll in
                ScrollView {
                    VStack {
                        headerView("Mode")
                            .id("top")
                        modeButtons
                        
                        headerView("Match Point")
                        matchPointButtons
                        
                        headerView("First Serve")
                        servingTeamButtons
                        
                        headerView("Starting Side")
                        startingSideButtons
                            
                        NavigationLink(destination: MatchView(matchSettings: matchSettings)) {
                            Text("Start Match")
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
            settingButton(title: "Doubles", isSelected: matchSettings.isDoubles) {
                matchSettings.isDoubles = true
            }
        }
    }
    
    private var matchPointButtons: some View {
        HStack {
            ForEach(matchSettings.matchPoints, id: \.self) { points in
                settingButton(title: "\(points)", isSelected: matchSettings.matchPoint == points) {
                    matchSettings.matchPoint = points
                }
            }
        }
    }
    
    private var servingTeamButtons: some View {
        HStack {
            settingButton(title: "Us", isSelected: matchSettings.servingTeam == "Us") {
                matchSettings.servingTeam = "Us"
            }
            settingButton(title: "Them", isSelected: matchSettings.servingTeam == "Them") {
                matchSettings.servingTeam = "Them"
            }
        }
    }
    
    private var startingSideButtons: some View {
        HStack {
            settingButton(title: "Left", isSelected: matchSettings.startingSide == "Left") {
                matchSettings.startingSide = "Left"
            }
            settingButton(title: "Right", isSelected: matchSettings.startingSide == "Right") {
                matchSettings.startingSide = "Right"
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

struct MatchSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSettings = MatchSettings()
        MatchSettingsView(matchSettings: sampleSettings)
    }
}
