import Foundation
import Combine

public class Match: ObservableObject { // Use public for shared access
    @Published public var playerOneName: String
    @Published public var playerTwoName: String
    @Published public var playerOneScore: Int = 0
    @Published public var playerTwoScore: Int = 0

    public init(playerOneName: String, playerTwoName: String) {
        self.playerOneName = playerOneName
        self.playerTwoName = playerTwoName
    }
}
