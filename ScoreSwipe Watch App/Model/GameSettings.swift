import SwiftUI

@Observable
class GameSettings {
    var isDoubles: Bool = true
    var gamePoint: Int = 11
    var servingTeam: String = "Us"
    var startingSide: String = "Left"
    
    let gamePoints = [11, 15, 21]
    
    func reset() {
        isDoubles = true
        gamePoint = 11
        servingTeam = "Us"
        startingSide = "Left"
    }
}
