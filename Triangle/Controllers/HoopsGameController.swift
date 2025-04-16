import SwiftUI

class HoopsGameController: ObservableObject {
    @Published private(set) var gameModel: HoopsGameModel
    private var screenWidth: CGFloat = 0
    
    init() {
        self.gameModel = HoopsGameModel()
        // Load high score from UserDefaults
        self.gameModel.highScore = UserDefaults.standard.integer(forKey: "HoopsHighScore")
    }
    
    func updateScreenWidth(_ width: CGFloat) {
        screenWidth = width
        // Initialize basket position in the center
        if gameModel.basketPosition == 0 {
            gameModel.basketPosition = width / 2
        }
    }
    
    func randomizeBasketPosition() {
        // Calculate the valid range for basket position
        let minPosition = HoopsGameModel.screenPadding + (HoopsGameModel.basketWidth / 2)
        let maxPosition = screenWidth - HoopsGameModel.screenPadding - (HoopsGameModel.basketWidth / 2)
        
        // Generate random position within valid range
        let randomPosition = CGFloat.random(in: minPosition...maxPosition)
        gameModel.basketPosition = randomPosition
    }
    
    func incrementScore() {
        gameModel.score += 1
        // Update high score if current score is higher
        if gameModel.score > gameModel.highScore {
            gameModel.highScore = gameModel.score
            // Save new high score
            UserDefaults.standard.set(gameModel.highScore, forKey: "HoopsHighScore")
        }
        // Randomize basket position for next throw
        randomizeBasketPosition()
    }
    
    func resetGame() {
        gameModel.score = 0
        gameModel.isGameActive = true
        randomizeBasketPosition()
    }
    
    func checkBasketScore(ballPosition: CGPoint) -> Bool {
        let basketLeft = gameModel.basketPosition - (HoopsGameModel.basketWidth / 2)
        let basketRight = gameModel.basketPosition + (HoopsGameModel.basketWidth / 2)
        let basketTop: CGFloat = 100 // Fixed vertical position for the basket
        
        // Check if ball is within basket bounds
        return ballPosition.x >= basketLeft &&
               ballPosition.x <= basketRight &&
               ballPosition.y >= basketTop &&
               ballPosition.y <= basketTop + HoopsGameModel.basketHeight
    }
} 