import Foundation

// Who serves first?
enum ServingTeam: String, CaseIterable {
    case ourTeam = "Our Team"
    case opponentTeam = "Opponent Team"
}

// Which side the player starts?
enum StartingSide: String, CaseIterable {
    case left = "Left"
    case right = "Right"
}

class MatchSettings: ObservableObject {
    @Published var isDoubles: Bool = true
    @Published var matchPoint: Int = 11
    @Published var servingTeam: ServingTeam = .ourTeam
    @Published var startingSide: StartingSide = .right
    
    let matchPoints = [11, 15, 21]

    func reset() {
        isDoubles = true
        matchPoint = 11
        servingTeam = .ourTeam
        startingSide = .right
    }
}
