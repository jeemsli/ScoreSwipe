import SwiftUI

@Observable
class Game {
    // Game settings
    var isDoubles: Bool = true
    var gamePoint: Int
    var servingTeam: String
    var startingSide: String
    
    // Score (0-0-2 start)
    var ourScore: Int = 0
    var opponentScore: Int = 0
    var position: Int = 2
    var gameFinished: Bool = false
    
    // Players
    var user: Player?
    var partner: Player?
    var opponentOne: Player?
    var opponentTwo: Player?
    
    private var undoStack: [(ourScore: Int, opponentScore: Int, position: Int, servingTeam: String, userisServing: Bool?, userSide: String?, partnerisServing: Bool?, partnerSide: String?, opponentOneisServing: Bool?, opponentOneSide: String?, opponentTwoisServing: Bool?, opponentTwoSide: String?)] = []

    // Set up game based on settings
    init(settings: GameSettings) {
        self.isDoubles = settings.isDoubles
        self.gamePoint = settings.gamePoint
        self.servingTeam = settings.servingTeam
        self.startingSide = settings.startingSide
        
        setUpPlayers(settings: settings)
    }
    
    // Create players
    func setUpPlayers(settings: GameSettings) {
        let isUserServing: Bool
        let isOpponentServing: Bool
        
        if settings.servingTeam == "Us" {
            isUserServing = settings.startingSide == "Right"
        } else {
            isUserServing = false
        }
        
        // Create user player
        self.user = Player(name: "Me", isOpponent: false, side: settings.startingSide, isServing: isUserServing)
        
        // Determine partner's serving status based on whether the user is serving
        let isPartnerServing = (settings.servingTeam == "Us" && settings.startingSide == "Left")
        self.partner = Player(name: "P", isOpponent: false, side: settings.startingSide == "Left" ? "Right" : "Left", isServing: isPartnerServing)
        
        // Opponent one is serving if the serving team is "Them"
        isOpponentServing = settings.servingTeam == "Them"
        self.opponentOne = Player(name: "1", isOpponent: true, side: "Right", isServing: isOpponentServing)
        self.opponentTwo = Player(name: "2", isOpponent: true, side: "Left", isServing: false)
    }
    
    // Check if game is finished
    func checkGameFinished() -> Bool {
        gameFinished = (ourScore >= gamePoint && ourScore >= (opponentScore + 2)) ||
        (opponentScore >= gamePoint && opponentScore >= (ourScore + 2))
        return gameFinished
    }
    
    // Switch team server
    func switchTeamServe() {
        if servingTeam == "Us" {
            if let user = user, let partner = partner {
                if user.isServing {
                    user.isServing = false
                    partner.isServing = true
                } else {
                    partner.isServing = false
                    user.isServing = true
                }
            }
        } else {
            if let opponentOne = opponentOne, let opponentTwo = opponentTwo {
                if opponentOne.isServing {
                    opponentOne.isServing = false
                    opponentTwo.isServing = true
                } else {
                    opponentTwo.isServing = false
                    opponentOne.isServing = true
                }
            }
        }
    }
    
    // Switch serve to other team
    func switchOtherTeamServe() {
        if servingTeam == "Us" {
            // Right side of opponent serves
            if let opponentOne = opponentOne, let opponentTwo = opponentTwo {
                if opponentOne.side == "Right" {
                    opponentOne.isServing = true
                    opponentTwo.isServing = false
                } else {
                    opponentTwo.isServing = true
                    opponentOne.isServing = false
                }
            }
            
            user?.isServing = false
            partner?.isServing = false
            
        } else {
            // Right side of user team serves
            if let user = user, let partner = partner {
                if user.side == "Right" {
                    user.isServing = true
                    partner.isServing = false
                } else {
                    partner.isServing = true
                    user.isServing = false
                }
            }
            
            opponentOne?.isServing = false
            opponentTwo?.isServing = false
        }
    }
    
    // Update our score
    func updateOurScore() {
        registerUndo()
        
        if servingTeam == "Them" {
            if position < 2 {
                position += 1
                // Switch serve to opponent team partner
                switchTeamServe()
            } else {
                // Switch serving team to us
                switchOtherTeamServe()
                servingTeam = "Us"
                position = 1
            }
        } else {
            ourScore += 1
            user?.switchSides()
            partner?.switchSides()
        }
    }
    
    // Update opponent score
    func updateOpponentScore() {
        registerUndo()
        
        if servingTeam == "Us" {
            if position < 2 {
                position += 1
                // Switch serve to partner
                switchTeamServe()
            } else {
                // Switch serving team to opponent
                switchOtherTeamServe()
                servingTeam = "Them"
                position = 1
            }
        } else {
            opponentScore += 1
            opponentOne?.switchSides()
            opponentTwo?.switchSides()
        }
    }
    
    // Register - scores, position, servingTeam, and player states (side and isServing)
    private func registerUndo() {
        let state = (ourScore, opponentScore, position, servingTeam, user?.isServing, user?.side, partner?.isServing, partner?.side, opponentOne?.isServing, opponentOne?.side, opponentTwo?.isServing, opponentTwo?.side)
        
        undoStack.append(state)
    }
    
    func undo() {
        guard let previousState = undoStack.popLast() else { return }
        
        ourScore = previousState.ourScore
        opponentScore = previousState.opponentScore
        position = previousState.position
        servingTeam = previousState.servingTeam
        
        user?.isServing = previousState.userisServing!
        user?.side = previousState.userSide!
        partner?.isServing = previousState.partnerisServing!
        partner?.side = previousState.partnerSide!
        opponentOne?.isServing = previousState.opponentOneisServing!
        opponentOne?.side = previousState.opponentOneSide!
        opponentTwo?.isServing = previousState.opponentTwoisServing!
        opponentTwo?.side = previousState.opponentTwoSide!
    }
    
    // Create new game based on settings
    func reset(settings: GameSettings) {
        isDoubles = true
        gamePoint = settings.gamePoint
        servingTeam = settings.servingTeam
        startingSide = settings.startingSide
        
        ourScore = 0
        opponentScore = 0
        position = 2
        gameFinished = false
        
        setUpPlayers(settings: settings)
        
        undoStack.removeAll()
    }
}
