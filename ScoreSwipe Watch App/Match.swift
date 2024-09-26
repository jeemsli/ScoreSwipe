import SwiftUI

@Observable
class Match {
    var isDoubles: Bool = true
    var matchPoint: Int
    var servingTeam: String
    var startingSide: String
    
    // Score (0-0-2 start)
    var ourScore: Int = 0
    var opponentScore: Int = 0
    var position: Int = 2
    var matchFinished: Bool = false
    
    // Players
    var user: Player?
    var partner: Player?
    var opponentOne: Player?
    var opponentTwo: Player?
    
    var undoManager: UndoManager?
    
    // Set up match based on settings
    init(settings: MatchSettings, undoManager: UndoManager? = nil) {
        self.isDoubles = settings.isDoubles
        self.matchPoint = settings.matchPoint
        self.servingTeam = settings.servingTeam
        self.startingSide = settings.startingSide
        
        self.undoManager = undoManager
        
        // Create players
        setUpPlayers(settings: settings)
    }
    
    func setUpPlayers(settings: MatchSettings) {
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
    
    // Check if match is finished
    func checkMatchFinished() -> Bool {
        matchFinished = (ourScore >= matchPoint && ourScore >= (opponentScore + 2)) ||
        (opponentScore >= matchPoint && opponentScore >= (ourScore + 2))
        return matchFinished
    }
    
    // Switch team server
    func switchTeamServe() {
        registerUndo()
        
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
        registerUndo()
        
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
    
    // Undo - scores, position, and player states (side and isServing)
    func registerUndo() {
        let previousOurScore = ourScore
        let previousOpponentScore = opponentScore
        let previousPosition = position
        
        let previousServingTeam = servingTeam
        
        let previousUserisServing = user?.isServing
        let previousUserSide = user?.side
        let previousPartnerisServing = partner?.isServing
        let previousPartnerSide = partner?.side
        let previousOpponentOneisServing = opponentOne?.isServing
        let previousOpponentOneSide = opponentOne?.side
        let previousOpponentTwoisServing = opponentTwo?.isServing
        let previousOpponentTwoSide = opponentTwo?.side
        
        // Register the undo action for all the relevant states
        if let undoManager = undoManager {
            undoManager.registerUndo(withTarget: self) { target in
                target.ourScore = previousOurScore
                target.opponentScore = previousOpponentScore
                target.position = previousPosition
                target.servingTeam = previousServingTeam
                target.user?.isServing = previousUserisServing!
                target.user?.side = previousUserSide!
                target.partner?.isServing = previousPartnerisServing!
                target.partner?.side = previousPartnerSide!
                target.opponentOne?.isServing = previousOpponentOneisServing!
                target.opponentOne?.side = previousOpponentOneSide!
                target.opponentTwo?.isServing = previousOpponentTwoisServing!
                target.opponentTwo?.side = previousOpponentTwoSide!
            }
        }
    }
    
    // Create new game based on settings
    func reset(settings: MatchSettings) {
        isDoubles = true
        matchPoint = settings.matchPoint
        servingTeam = settings.servingTeam
        startingSide = settings.startingSide
        
        ourScore = 0
        opponentScore = 0
        position = 2
        matchFinished = false
        
        setUpPlayers(settings: settings)
    }
}
