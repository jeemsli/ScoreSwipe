//
//  ContentView.swift
//  ScoreSwipe Watch App
//
//  Created by James Li on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    var matchSettings = MatchSettings()

    var body: some View {
        VStack {
            MatchSettingsView(matchSettings: matchSettings)
        }
    }
}

#Preview {
    ContentView()
}
