import SwiftUI

@Observable
class Player {
    var name: String
    var isOpponent: Bool
    var side: String
    var isServing: Bool
    
    init(name: String, isOpponent: Bool, side: String, isServing: Bool) {
        self.name = name
        self.isOpponent = isOpponent
        self.side = side
        self.isServing = isServing
    }
    
    func switchSides() {
        side = side == "Left" ? "Right" : "Left"
    }
}
