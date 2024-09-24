import SwiftUI

//struct MatchSettingsView: View {
//    @ObservedObject var matchSettings: MatchSettings
//
//    let columns = [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: columns) {
//                // Mode Picker
//                VStack {
//                    Text("Mode")
//                    Picker("Mode", selection: $matchSettings.isDoubles) {
//                        Text("Doubles")
//                    }
//                    .labelsHidden()
//                    .frame(minWidth: 50, minHeight: 35)
//                }
//
//                // Match Point Selector
//                VStack {
//                    Text("Point")
//                    Picker("Point", selection: $matchSettings.matchPoint) {
//                        ForEach(matchSettings.matchPoints, id: \.self) { points in
//                            Text("\(points)")
//                        }
//                    }
//                    .labelsHidden()
//                    .frame(minWidth: 50, minHeight: 35)
//                }
//
//                // First Serve Picker
//                VStack {
//                    Text("Serving")
//                    Picker("Serving", selection: $matchSettings.servingTeam) {
//                        Text("Us")
//                        Text("Them")
//                    }
//                    .labelsHidden()
//                    .frame(minWidth: 50, minHeight: 35)
//                }
//
//                // Side Picker
//                VStack {
//                    Text("Side")
//                    Picker("Side", selection: $matchSettings.startingSide) {
//                        Text("Right")
//                        Text("Left")
//                    }
//                    .labelsHidden()
//                    .frame(minWidth: 50, minHeight: 35)
//                }
//            }
//            .padding(.bottom)
//
//            Button("Go") {
//
//            }
//            .foregroundStyle(.green)
//        }
//    }
//}

struct MatchSettingsView: View {
    @ObservedObject var matchSettings: MatchSettings
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Mode")
                        .font(.headline)
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
                            matchSettings.servingTeam = .ourTeam
                        }
                        .background(matchSettings.servingTeam == .ourTeam ? Color.blue : Color.black)
                        .clipShape(.capsule)
                        .opacity(matchSettings.servingTeam == .ourTeam ? 1 : 0.5)
                        
                        Button("Them") {
                            matchSettings.servingTeam = .opponentTeam
                        }
                        .background(matchSettings.servingTeam == .opponentTeam ? Color.blue : Color.black)
                        .clipShape(.capsule)
                        .opacity(matchSettings.servingTeam == .opponentTeam ? 1 : 0.5)
                    }
                    
                    Text("Starting Side")
                        .font(.headline)
                    HStack {
                        Button("Left") {
                            matchSettings.startingSide = .left
                        }
                        .background(matchSettings.startingSide == .left ? Color.blue : Color.black)
                        .clipShape(.capsule)
                        .opacity(matchSettings.startingSide == .left ? 1 : 0.5)
                        
                        Button("Right") {
                            matchSettings.startingSide = .right
                        }
                        .background(matchSettings.startingSide == .right ? Color.blue : Color.black)
                        .clipShape(.capsule)
                        .opacity(matchSettings.startingSide == .right ? 1 : 0.5)
                    }
                    .padding(.bottom)
                    
                    Button("Go") {
                        
                    }
                    .foregroundStyle(.green)
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
