import SpriteKit
import SwiftUI

class HoopsGameScene: SKScene {
    private var hoop: SKSpriteNode!
    private var backgroundScoreLabel: SKLabelNode!
    private var livesNodes: [SKSpriteNode] = []
    private var gameOverLabel: SKLabelNode?
    private var score: Int = 0
    private var lives: Int = 3
    private var gameTimer: Timer?
    private var lastUpdateTime: TimeInterval = 0
    private var isGameOver: Bool = false
    private var gameStarted: Bool = false
    
    // Game constants
    private let hoopWidth: CGFloat = 120
    private let hoopHeight: CGFloat = 120  // Made equal to width to maintain aspect ratio
    private let ballSize: CGFloat = 40
    private let hoopSpeed: CGFloat = 500 // Points per second
    private let ballSpeed: CGFloat = 300 // Points per second
    private let spawnInterval: TimeInterval = 1.5 // Seconds between ball spawns
    
    override func didMove(to view: SKView) {
        // Convert ColorTheme.background (SwiftUI Color) to UIColor for SpriteKit
        backgroundColor = UIColor(red: 0.71, green: 0.81, blue: 0.89, alpha: 1.0) // B5CFE3
        setupGame()
        // Don't start game automatically
        // Game will be started via the startGame method
    }
    
    func startGame() {
        gameStarted = true
        isGameOver = false
        lives = 3
        score = 0
        
        // Ensure background score label exists and is visible
        if backgroundScoreLabel == nil {
            backgroundScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
            backgroundScoreLabel.text = "0"
            backgroundScoreLabel.fontSize = 200
            backgroundScoreLabel.fontColor = UIColor(red: 0.67, green: 0.77, blue: 0.85, alpha: 1.0)
            backgroundScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
            backgroundScoreLabel.zPosition = -1
            addChild(backgroundScoreLabel)
        } else {
            backgroundScoreLabel.text = "0"
            backgroundScoreLabel.isHidden = false
        }
        
        updateLivesDisplay()
        
        // Start spawning balls
        gameTimer = Timer.scheduledTimer(withTimeInterval: spawnInterval, repeats: true) { [weak self] _ in
            self?.spawnBall()
        }
    }
    
    private func setupGame() {
        // Background score label
        backgroundScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backgroundScoreLabel.text = "0"
        backgroundScoreLabel.fontSize = 200
        backgroundScoreLabel.fontColor = UIColor(red: 0.67, green: 0.77, blue: 0.85, alpha: 1.0) // Slightly darker than background
        backgroundScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundScoreLabel.zPosition = -1 // Behind everything
        addChild(backgroundScoreLabel)
        
        // Hoop
        hoop = SKSpriteNode(imageNamed: "basketball_hoop")
        hoop.size = CGSize(width: hoopWidth, height: hoopHeight)
        hoop.position = CGPoint(x: frame.midX, y: hoopHeight)
        addChild(hoop)
        
        // Setup lives indicators
        setupLivesIndicators()
    }
    
    private func setupLivesIndicators() {
        let heartSize: CGFloat = 30
        let spacing: CGFloat = 10
        let startX = frame.width - (heartSize + spacing) * 3
        let startY = frame.height - 120 // Position below the navigation bar
        
        for i in 0..<3 {
            let heart = SKSpriteNode(imageNamed: "basketball")
            heart.size = CGSize(width: heartSize, height: heartSize)
            heart.position = CGPoint(x: startX + (heartSize + spacing) * CGFloat(i), y: startY)
            livesNodes.append(heart)
            addChild(heart)
        }
    }
    
    private func updateLivesDisplay() {
        for (index, node) in livesNodes.enumerated() {
            node.alpha = index < lives ? 1.0 : 0.3
        }
    }
    
    private func loseLife() {
        guard !isGameOver else { return }
        
        lives -= 1
        updateLivesDisplay()
        
        if lives <= 0 {
            gameOver()
        }
    }
    
    private func gameOver() {
        isGameOver = true
        gameTimer?.invalidate()
        gameTimer = nil
        
        // Show game over message
        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = UIColor(red: 0.45, green: 0.44, blue: 0.44, alpha: 1.0)
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        addChild(gameOverLabel)
        
        // Show final score
        let finalScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.fontSize = 40
        finalScoreLabel.fontColor = UIColor(red: 0.45, green: 0.44, blue: 0.44, alpha: 1.0)
        finalScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 40)
        addChild(finalScoreLabel)
        
        // Show tap to restart message
        let tapToRestartLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        tapToRestartLabel.text = "Tap to Restart"
        tapToRestartLabel.fontSize = 30
        tapToRestartLabel.fontColor = UIColor(red: 0.45, green: 0.44, blue: 0.44, alpha: 1.0)
        tapToRestartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        addChild(tapToRestartLabel)
        
        self.gameOverLabel = gameOverLabel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            // Remove game over labels
            gameOverLabel?.parent?.children.forEach { node in
                if node is SKLabelNode && node != backgroundScoreLabel {
                    node.removeFromParent()
                }
            }
            
            // Remove any remaining balls
            enumerateChildNodes(withName: "ball") { node, _ in
                node.removeFromParent()
            }
            
            // Reset and show background score label
            backgroundScoreLabel.text = "0"
            backgroundScoreLabel.isHidden = false
            backgroundScoreLabel.zPosition = -1
            
            // Restart the game
            startGame()
        }
    }
    
    private func spawnBall() {
        guard !isGameOver else { return }
        
        let ball = SKSpriteNode(imageNamed: "basketball")
        ball.name = "ball"
        ball.size = CGSize(width: ballSize, height: ballSize)
        
        // Random x position at the top of the screen
        let minX = ballSize/2
        let maxX = frame.width - ballSize/2
        let randomX = CGFloat.random(in: minX...maxX)
        ball.position = CGPoint(x: randomX, y: frame.height + ballSize)
        
        addChild(ball)
        
        // Move ball down
        let moveAction = SKAction.moveTo(y: -ballSize, duration: TimeInterval(frame.height / ballSpeed))
        let removeAction = SKAction.run { [weak self] in
            if ball.position.y < 0 {
                self?.loseLife() // Lose a life if ball goes below screen
            }
            ball.removeFromParent()
        }
        ball.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver, let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        let dx = location.x - previousLocation.x
        
        // Move hoop horizontally, but keep it within screen bounds
        let newX = hoop.position.x + dx
        let minX = hoopWidth/2
        let maxX = frame.width - hoopWidth/2
        hoop.position.x = max(min(newX, maxX), minX)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Calculate time since last update
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        guard !isGameOver else { return }
        
        // Check for collisions between balls and hoop
        enumerateChildNodes(withName: "ball") { [weak self] ball, _ in
            guard let self = self else { return }
            
            // Skip if ball is already caught (has no name)
            guard ball.name != nil else { return }
            
            let ballFrame = ball.frame
            let hoopFrame = self.hoop.frame
            
            // Check if ball is within catching range
            if ballFrame.maxY > hoopFrame.minY &&
               ballFrame.minY < hoopFrame.maxY &&
               ballFrame.midX > hoopFrame.minX + 10 &&
               ballFrame.midX < hoopFrame.maxX - 10 {
                
                // Remove the ball's name so it won't be counted again
                ball.name = nil
                
                // Ball is caught
                self.score += 1
                self.backgroundScoreLabel.text = "\(self.score)"
                
                // Add catch effect
                let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
                let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
                ball.run(SKAction.sequence([scaleUp, scaleDown])) {
                    ball.removeFromParent()
                }
            }
        }
    }
    
    override func willMove(from view: SKView) {
        gameTimer?.invalidate()
        gameTimer = nil
    }
} 