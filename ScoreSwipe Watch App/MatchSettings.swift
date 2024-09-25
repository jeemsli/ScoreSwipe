import Foundation

@Observable
class MatchSettings {
    var isDoubles: Bool = true
    var matchPoint: Int = 11
    var servingTeam: String = "Us"
    var startingSide: String = "Left"
    
    let matchPoints = [11, 15, 21]
    
    func reset() {
        isDoubles = true
        matchPoint = 11
        servingTeam = "Us"
        startingSide = "Left"
    }
}
