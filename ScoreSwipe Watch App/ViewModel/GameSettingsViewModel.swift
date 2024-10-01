import SwiftUI

@Observable
class GameSettingsViewModel {
    var gameSettings: GameSettings
    
    init(gameSettings: GameSettings = GameSettings()) {
        self.gameSettings = gameSettings
    }
    
    func selectMode(isDoubles: Bool) {
        gameSettings.isDoubles = isDoubles
    }
    
    func selectGamePoint(_ point: Int) {
        gameSettings.gamePoint = point
    }
    
    func selectServingTeam(_ team: String) {
        gameSettings.servingTeam = team
    }
    
    func selectStartingSide(_ side: String) {
        gameSettings.startingSide = side
    }
}
