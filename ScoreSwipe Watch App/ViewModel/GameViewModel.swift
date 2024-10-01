import SwiftUI

@Observable
class GameViewModel {
    private var game: Game
    
    var ourScore: Int {
        game.ourScore
    }
    
    var opponentScore: Int {
        game.opponentScore
    }
    
    var servingTeam: String {
        game.servingTeam
    }
    
    var position: Int {
        game.position
    }
    
    var user: Player? {
        game.user
    }
    
    var partner: Player? {
        game.partner
    }
    
    var opponentOne: Player? {
        game.opponentOne
    }
    
    var opponentTwo: Player? {
        game.opponentTwo
    }
    
    var gameFinished: Bool {
        game.checkGameFinished()
    }
    
    // Initialize with GameSettings
    init(settings: GameSettings) {
        self.game = Game(settings: settings)
    }
    
    // Update our score
    func updateOurScore() {
        game.updateOurScore()
    }
    
    // Update opponent score
    func updateOpponentScore() {
        game.updateOpponentScore()
    }
    
    // Switch team server
    func switchTeamServe() {
        game.switchTeamServe()
    }
    
    // Switch serve to other team
    func switchOtherTeamServe() {
        game.switchOtherTeamServe()
    }
    
    // Undo last action
    func undo() {
        game.undo()
    }
    
    // Reset game with new settings
    func reset(settings: GameSettings) {
        game.reset(settings: settings)
    }
}
