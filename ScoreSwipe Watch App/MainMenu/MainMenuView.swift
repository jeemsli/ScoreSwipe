import SwiftUI

struct MainMenuView: View {
    @State private var showUserGuide = false
    var matchSettings = MatchSettings()

    var body: some View {
        NavigationView {
            ZStack {
                backgroundImage
                VStack(spacing: 10) {
                    titleText
                    startMatchButton
                    userGuideButton
                }
                .padding()
            }
        }
    }

    private var backgroundImage: some View {
        Image(.scoreSwipe)
            .resizable()
            .scaledToFill()
            .opacity(0.1)
    }

    private var titleText: some View {
        Text("ScoreSwipe")
            .font(.title2)
            .fontDesign(.rounded)
            .fontWeight(.bold)
            .scaledToFill()
    }

    private var startMatchButton: some View {
        NavigationLink(destination: MatchSettingsView(matchSettings: matchSettings)) {
            Text("Start")
                .font(.headline)
                .foregroundStyle(.green)
                .brightness(0.15)
        }
    }

    private var userGuideButton: some View {
        Button(action: {
            showUserGuide.toggle()
        }) {
            Text("User Guide")
                .font(.headline)
                .foregroundStyle(.blue)
                .brightness(0.15)
        }
        .sheet(isPresented: $showUserGuide) {
            UserGuideView()
        }
    }
}

#Preview {
    MainMenuView()
}
