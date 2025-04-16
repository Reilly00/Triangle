import SpriteKit

class BrickBreakerScene: SKScene, SKPhysicsContactDelegate {
    private var paddle: SKSpriteNode!
    private var ball: SKSpriteNode!
    private var bricks: [SKSpriteNode] = []
    private var score: Int = 0
    private var round: Int = 1
    private var backgroundScoreLabel: SKLabelNode!
    private var gameOverLabel: SKLabelNode!
    private var gameWonLabel: SKLabelNode!
    private var roundLabel: SKLabelNode!
    private var isGameOver: Bool = false
    private var isGameWon: Bool = false
    private var gameStarted: Bool = false
    
    // Game configuration
    private let paddleWidth: CGFloat = 100
    private let paddleHeight: CGFloat = 20
    private let ballSize: CGFloat = 15
    private let baseBrickWidth: CGFloat = 160 
    private let baseBrickHeight: CGFloat = 60
    private let baseBrickSpacing: CGFloat = 10
    private let baseBrickRows: Int = 1
    private let baseBrickColumns: Int = 2
    
    private var currentBrickWidth: CGFloat {
        return baseBrickWidth - CGFloat(round - 1) * 10 // Decrease by 10 each round
    }
    
    private var currentBrickHeight: CGFloat {
        return baseBrickHeight - CGFloat(round - 1) * 5 // Decrease by 5 each round
    }
    
    private var currentBrickSpacing: CGFloat {
        return baseBrickSpacing - CGFloat(round - 1) * 2 // Decrease by 2 each round
    }
    
    private var currentBrickRows: Int {
        return baseBrickRows + (round - 1) * 2 // Add 2 rows per round
    }
    
    private var currentBrickColumns: Int {
        return baseBrickColumns + (round - 1) // Add 1 column per round
    }
    
    private var scoreLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.71, green: 0.81, blue: 0.89, alpha: 1.0) // B5CFE3
        physicsWorld.contactDelegate = self
        setupGame()
        setupPhysics()
        setupBricks()
        setupLabels()
        setupWalls()
    }
    
    private func setupGame() {
        // Background score label
        backgroundScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backgroundScoreLabel.text = "0"
        backgroundScoreLabel.fontSize = 200
        backgroundScoreLabel.fontColor = UIColor(red: 0.67, green: 0.77, blue: 0.85, alpha: 1.0)
        backgroundScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundScoreLabel.zPosition = -1
        addChild(backgroundScoreLabel)
        
        // Setup paddle
        paddle = SKSpriteNode(color: UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0), size: CGSize(width: paddleWidth, height: paddleHeight))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        addChild(paddle)
        
        // Setup ball
        setupBall()
    }
    
    private func setupPhysics() {
        // Ball physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize/2)
        ball.physicsBody?.isDynamic = false  // Start with ball not moving
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.mass = 0.05
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.brick | PhysicsCategory.paddle | PhysicsCategory.wall
        ball.physicsBody?.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.wall | PhysicsCategory.brick
        
        // Paddle physics
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.restitution = 1.0
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.categoryBitMask = PhysicsCategory.paddle
        paddle.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        
        // Create a frame for the gameplay area
        let gameFrame = SKNode()
        gameFrame.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 100))
        gameFrame.physicsBody?.isDynamic = false
        gameFrame.physicsBody?.restitution = 1.0
        gameFrame.physicsBody?.friction = 0
        gameFrame.physicsBody?.categoryBitMask = PhysicsCategory.wall
        gameFrame.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        addChild(gameFrame)
    }
    
    private func setupBricks() {
        let startX = (frame.width - CGFloat(currentBrickColumns) * (currentBrickWidth + currentBrickSpacing)) / 2
        let startY = frame.height - 200
        
        for row in 0..<currentBrickRows {
            for col in 0..<currentBrickColumns {
                let brick = SKSpriteNode(color: UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0), 
                                       size: CGSize(width: currentBrickWidth, height: currentBrickHeight))
                brick.position = CGPoint(
                    x: startX + CGFloat(col) * (currentBrickWidth + currentBrickSpacing) + currentBrickWidth/2,
                    y: startY - CGFloat(row) * (currentBrickHeight + currentBrickSpacing) - currentBrickHeight/2
                )
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false
                brick.physicsBody?.restitution = 1.0
                brick.physicsBody?.friction = 0
                brick.physicsBody?.categoryBitMask = PhysicsCategory.brick
                brick.physicsBody?.contactTestBitMask = PhysicsCategory.ball
                brick.physicsBody?.collisionBitMask = PhysicsCategory.ball
                addChild(brick)
                bricks.append(brick)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Don't move paddle if game is over or won
        guard !isGameOver && !isGameWon else { return }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Move paddle with touch, keeping it within screen bounds
        let newX = min(max(location.x, paddleWidth/2), frame.width - paddleWidth/2)
        paddle.position.x = newX
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            restartGame()
        } else if bricks.isEmpty && isGameWon {
            startNextRound()
        } else if !gameStarted {
            gameStarted = true
            ball.physicsBody?.isDynamic = true
            let randomAngle = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
            let speed: CGFloat = 400
            let dx = speed * sin(randomAngle)
            let dy = speed * cos(randomAngle)
            ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        }
    }
    
    private func restartGame() {
        // Remove existing ball if it exists
        ball.removeFromParent()
        
        // Remove any existing game over labels
        enumerateChildNodes(withName: "gameOverLabel") { node, _ in
            node.removeFromParent()
        }
        
        // Reset game state
        isGameOver = false
        isGameWon = false
        score = 0
        round = 1
        gameStarted = false
        
        // Update labels
        updateLabels()
        
        // Reset paddle position
        paddle.position.x = frame.midX
        
        // Setup new ball
        setupBall()
        
        // Remove all bricks and create new ones
        bricks.forEach { $0.removeFromParent() }
        bricks.removeAll()
        setupBricks()
    }
    
    private func loseLife() {
        gameOver()
    }
    
    private func gameOver() {
        isGameOver = true
        ball.removeFromParent()
        ball.physicsBody?.isDynamic = false
        score = 0
        backgroundScoreLabel.text = "0"
        
        // Show game over label
        gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.name = "gameOverLabel"
        addChild(gameOverLabel)
        
        // Show tap to restart label
        let tapLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        tapLabel.text = "Tap to Restart"
        tapLabel.fontSize = 24
        tapLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        tapLabel.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        tapLabel.name = "gameOverLabel"
        addChild(tapLabel)
    }
    
    private func gameWon() {
        isGameWon = true
        
        // Remove the ball and stop its physics
        ball.physicsBody?.isDynamic = false
        ball.removeFromParent()
        
        // Remove any existing game over labels
        enumerateChildNodes(withName: "gameOverLabel") { node, _ in
            node.removeFromParent()
        }
        
        let winLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        winLabel.text = "You Win!"
        winLabel.fontSize = 48
        winLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        winLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        winLabel.name = "gameOverLabel"
        addChild(winLabel)
        
        let tapToRestartLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        tapToRestartLabel.text = "Tap to Play Again"
        tapToRestartLabel.fontSize = 24
        tapToRestartLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        tapToRestartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 40)
        tapToRestartLabel.name = "gameOverLabel"
        addChild(tapToRestartLabel)
    }
    
    private func roundCompleted() {
        // Set game won state
        isGameWon = true
        
        // Remove the ball
        ball.removeFromParent()
        
        // Create round completed label
        let roundLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        roundLabel.text = "Round \(round) Completed!"
        roundLabel.fontSize = 32
        roundLabel.fontColor = .white
        roundLabel.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        roundLabel.name = "roundCompletedLabel"
        addChild(roundLabel)
        
        // Create tap to continue label
        let tapLabel = SKLabelNode(fontNamed: "AvenirNext-Regular")
        tapLabel.text = "Tap to continue"
        tapLabel.fontSize = 24
        tapLabel.fontColor = .white
        tapLabel.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        tapLabel.name = "tapToContinueLabel"
        addChild(tapLabel)
    }
    
    private func startNextRound() {
        isGameWon = false
        gameStarted = false
        // Remove round completed labels
        enumerateChildNodes(withName: "roundCompletedLabel") { node, _ in
            node.removeFromParent()
        }
        enumerateChildNodes(withName: "tapToContinueLabel") { node, _ in
            node.removeFromParent()
        }
        
        // Increment round
        round += 1
        
        // Update labels
        updateLabels()
        
        // Reset ball and paddle positions
        setupBall()
        paddle.position.x = frame.midX
        
        // Setup new bricks
        setupBricks()
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        // Ball hit bottom wall
        if collision == (PhysicsCategory.ball | PhysicsCategory.bottomWall) {
            loseLife()
        }
        
        // Ball hit brick
        if collision == (PhysicsCategory.ball | PhysicsCategory.brick) {
            let brick = (contact.bodyA.categoryBitMask == PhysicsCategory.brick) ? contact.bodyA.node : contact.bodyB.node
            if let brickNode = brick as? SKSpriteNode {
                destroyBrick(brickNode)
            }
        }
        
        // Ball hit paddle - implement angle-based bouncing
        if collision == (PhysicsCategory.ball | PhysicsCategory.paddle) {
            if let velocity = ball.physicsBody?.velocity {
                // Calculate where the ball hit the paddle (0 = center, -1 = left edge, 1 = right edge)
                let paddleCenter = paddle.position.x
                let ballX = ball.position.x
                let paddleHalfWidth = paddleWidth / 2
                let hitPosition = (ballX - paddleCenter) / paddleHalfWidth
                
                // Calculate new velocity based on hit position
                let baseSpeed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)
                let maxAngle: CGFloat = .pi / 3 // 60 degrees
                let angle = hitPosition * maxAngle
                
                // Ensure the ball always goes upward
                let newVelocity = CGVector(
                    dx: baseSpeed * sin(angle),
                    dy: abs(baseSpeed * cos(angle))
                )
                
                ball.physicsBody?.velocity = newVelocity
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard (!isGameOver || !isGameWon) && gameStarted else { return }
        
        // Check if ball went below paddle
        if ball.position.y < paddle.position.y {
            loseLife()
        }
    }
    
    private func destroyBrick(_ brick: SKSpriteNode) {
        // Remove brick from array and scene
        if let index = bricks.firstIndex(of: brick) {
            bricks.remove(at: index)
            brick.removeFromParent()
            
            // Update score
            score += 1
            backgroundScoreLabel.text = "\(score)"
            
            // Check if all bricks are destroyed
            if bricks.isEmpty {
                roundCompleted()
            }
        }
    }
    
    private func setupLabels() {
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        scoreLabel.position = CGPoint(x: frame.minX + 100, y: frame.maxY - 50)
        addChild(scoreLabel)
        
        // Round label
        roundLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        roundLabel.text = "Round: 1"
        roundLabel.fontSize = 24
        roundLabel.fontColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        roundLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        addChild(roundLabel)
    }
    
    private func setupWalls() {
        // Left wall
        let leftWall = SKSpriteNode(color: .clear, size: CGSize(width: 20, height: frame.height))
        leftWall.position = CGPoint(x: frame.minX + 10, y: frame.midY)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        leftWall.physicsBody?.contactTestBitMask = 0
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(leftWall)
        
        // Right wall
        let rightWall = SKSpriteNode(color: .clear, size: CGSize(width: 20, height: frame.height))
        rightWall.position = CGPoint(x: frame.maxX - 10, y: frame.midY)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        rightWall.physicsBody?.contactTestBitMask = 0
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(rightWall)
        
        // Top wall
        let topWall = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 20))
        topWall.position = CGPoint(x: frame.midX, y: frame.maxY - 10)
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        topWall.physicsBody?.contactTestBitMask = 0
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(topWall)
        
        // Bottom wall (invisible)
        let bottomWall = SKSpriteNode(color: .clear, size: CGSize(width: frame.width, height: 20))
        bottomWall.position = CGPoint(x: frame.midX, y: frame.minY + 10)
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.bottomWall
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        bottomWall.physicsBody?.collisionBitMask = 0
        addChild(bottomWall)
    }
    
    private func updateLabels() {
        scoreLabel.text = "Score: \(score)"
        roundLabel.text = "Round: \(round)"
    }
    
    private func setupBall() {
        let ballShape = SKShapeNode(circleOfRadius: ballSize/2)
        ballShape.fillColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        ballShape.strokeColor = UIColor(red: 0.30, green: 0.44, blue: 0.54, alpha: 1.0)
        ballShape.lineWidth = 0
        
        ball = SKSpriteNode()
        ball.addChild(ballShape)
        ball.size = CGSize(width: ballSize, height: ballSize)
        ball.position = CGPoint(x: frame.midX, y: frame.minY + 120)
        addChild(ball)
        
        // Setup ball physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballSize/2)
        ball.physicsBody?.isDynamic = false  // Start with ball not moving
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.mass = 0.05
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.brick | PhysicsCategory.paddle | PhysicsCategory.wall
        ball.physicsBody?.collisionBitMask = PhysicsCategory.paddle | PhysicsCategory.wall | PhysicsCategory.brick
    }
    
    private func startGame() {
        gameStarted = true
        ball.physicsBody?.isDynamic = true
        let randomAngle = CGFloat.random(in: -CGFloat.pi/4...CGFloat.pi/4)
        let speed: CGFloat = 400
        let dx = speed * sin(randomAngle)
        let dy = speed * cos(randomAngle)
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
}

// Physics categories for collision detection
private struct PhysicsCategory {
    static let none: UInt32 = 0
    static let ball: UInt32 = 1
    static let paddle: UInt32 = 2
    static let brick: UInt32 = 4
    static let wall: UInt32 = 8
    static let bottomWall: UInt32 = 16
} 