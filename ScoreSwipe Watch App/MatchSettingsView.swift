import SwiftUI

struct MatchSettingsView: View {
    var matchSettings: MatchSettings
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scroll in
                ScrollView {
                    VStack {
                        Text("Mode")
                            .font(.headline)
                            .id("top")
                        HStack {
                            Button("Doubles") {
                                matchSettings.isDoubles = true
                            }
                            .background(matchSettings.isDoubles ? Color.blue : Color.black)
                            .clipShape(.capsule)
                            .animation(.snappy, value: matchSettings.servingTeam)
                        }
                        
                        Text("Match Point")
                            .font(.headline)
                        HStack {
                            ForEach(matchSettings.matchPoints, id: \.self) { points in
                                Button("\(points)") {
                                    matchSettings.matchPoint = points
                                }
                                .background(matchSettings.matchPoint == points ? Color.blue : Color.black)
                                .clipShape(.capsule)
                                .opacity(matchSettings.matchPoint == points ? 1 : 0.5)
                            }
                        }
                        
                        Text("First Serve")
                            .font(.headline)
                        HStack {
                            Button("Us") {
                                matchSettings.servingTeam = "Us"
                            }
                            .background(matchSettings.servingTeam == "Us" ? Color.blue : Color.black)
                            .clipShape(.capsule)
                            .opacity(matchSettings.servingTeam == "Us" ? 1 : 0.5)
                            
                            Button("Them") {
                                matchSettings.servingTeam = "Them"
                            }
                            .background(matchSettings.servingTeam == "Them" ? Color.blue : Color.black)
                            .clipShape(.capsule)
                            .opacity(matchSettings.servingTeam == "Them" ? 1 : 0.5)
                        }
                        
                        Text("Starting Side")
                            .font(.headline)
                        HStack {
                            Button("Left") {
                                matchSettings.startingSide = "Left"
                            }
                            .background(matchSettings.startingSide == "Left" ? Color.blue : Color.black)
                            .clipShape(.capsule)
                            .opacity(matchSettings.startingSide == "Left" ? 1 : 0.5)
                            
                            Button("Right") {
                                matchSettings.startingSide = "Right"
                            }
                            .background(matchSettings.startingSide == "Right" ? Color.blue : Color.black)
                            .clipShape(.capsule)
                            .opacity(matchSettings.startingSide == "Right" ? 1 : 0.5)
                        }
                        .padding(.bottom)
                        
                        NavigationLink(destination: MatchView(matchSettings: matchSettings)) {
                            Text("Start Match")
                                .foregroundStyle(.green)
                        }
                    }
                }
                .onAppear {
                    scroll.scrollTo("top", anchor: .top)
                }
            }
        }
    }
}

struct MatchSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSettings = MatchSettings()
        MatchSettingsView(matchSettings: sampleSettings)
    }
}
