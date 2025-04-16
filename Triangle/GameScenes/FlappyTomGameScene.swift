//
//  FlappyTomView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 24.03.2025.
//

import SpriteKit

class FlappyTomGameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Properties
    var player: SKNode!
    var gameStarted = false
    var gameOver = false
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")

    // Physics Categories
    struct PhysicsCategory {
        static let player: UInt32 = 0x1 << 0
        static let obstacle: UInt32 = 0x1 << 1
        static let ground: UInt32 = 0x1 << 2
        static let score: UInt32 = 0x1 << 3
    }

    // MARK: - Scene Setup
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(ColorTheme.background)
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self

        createPlayer()
        createGround()
        createScoreLabel()
        
        // Pause physics until game starts
        physicsWorld.speed = 0
    }

    // TODO: Make the player the current character with customisations
    func createPlayer() {
        let characterNode = CharacterNode()

        // Scale
        characterNode.position = CGPoint(x: frame.midX / 2, y: frame.midY)
        characterNode.setScale(0.15)

        // Compute the accumulated frame of the character node so we know its visible bounds.
        let boundingRect = characterNode.calculateAccumulatedFrame()

        // Create a physics body from the texture (character body without cosmetics)
        if let baseTexture = characterNode.children.first as? SKSpriteNode,
            let texture = baseTexture.texture
        {
            characterNode.physicsBody = SKPhysicsBody(
                texture: texture, size: boundingRect.size)
        } else {
            // Fallback in case something goes wrong: use a rectangle physics body
            characterNode.physicsBody = SKPhysicsBody(
                rectangleOf: boundingRect.size)
        }

        // Set physics properties
        characterNode.physicsBody?.categoryBitMask = PhysicsCategory.player
        characterNode.physicsBody?.contactTestBitMask =
            PhysicsCategory.obstacle | PhysicsCategory.ground
            | PhysicsCategory.score
        characterNode.physicsBody?.collisionBitMask =
            PhysicsCategory.obstacle | PhysicsCategory.ground
        characterNode.physicsBody?.isDynamic = true
        characterNode.physicsBody?.affectedByGravity = true
        characterNode.physicsBody?.applyTorque(-10)

        player = characterNode
        addChild(player)
    }

    func createGround() {
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: 0)
        ground.physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(width: frame.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
    }

    func createScoreLabel() {
        scoreLabel.fontSize = 200
        scoreLabel.fontColor = UIColor(ColorTheme.primary).withAlphaComponent(0.2)
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = -1  // Place behind other elements
        scoreLabel.text = "0"
        addChild(scoreLabel)
    }

    // MARK: - Game State Management
    
    func startGame() {
        gameStarted = true
        physicsWorld.speed = 1.0
        startSpawningObstacles()
    }

    // MARK: - Obstacle Spawning

    func startSpawningObstacles() {
        let spawn = SKAction.run { [weak self] in
            self?.spawnObstaclePair()
        }
        let delay = SKAction.wait(forDuration: 4.0)
        let spawnSequence = SKAction.sequence([spawn, delay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever, withKey: "spawning")
    }

    func spawnObstaclePair() {
        
        // Gap size
        let gapMultiplier = 3.0 // This says how many times bigger the gaps are based on player's size (3 = Gap is 3x Player height)
        let gapHeight =
            player.calculateAccumulatedFrame().height * gapMultiplier
        let obstacleWidth: CGFloat = 120.0

        // Randomize vertical position for the gap
        let maxY = frame.height - gapHeight / 2
        let minY = gapHeight / 2
        let randomY = CGFloat.random(in: minY...maxY)

        // Bottom obstacle
        let bottomHeight = randomY - gapHeight / 2
        let bottomObstacle = SKSpriteNode(
            color: UIColor(ColorTheme.currentLevelColor),
            size: CGSize(width: obstacleWidth, height: bottomHeight))
        // Set the anchor point so that the top edge aligns with the visible sprite
        bottomObstacle.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        bottomObstacle.position = CGPoint(
            x: frame.width + obstacleWidth / 2, y: randomY - gapHeight / 2)
        // Create the physics body with a center offset to match the anchor point
        bottomObstacle.physicsBody = SKPhysicsBody(
            rectangleOf: bottomObstacle.size,
            center: CGPoint(x: 0, y: -bottomObstacle.size.height / 2)
        )
        bottomObstacle.physicsBody?.isDynamic = false
        bottomObstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        addChild(bottomObstacle)

        // Top obstacle
        let topHeight = frame.height - (randomY + gapHeight / 2)
        let topObstacle = SKSpriteNode(
            color: UIColor(ColorTheme.currentLevelColor),
            size: CGSize(width: obstacleWidth, height: topHeight))
        // Set the anchor point so that the bottom edge aligns with the visible sprite
        topObstacle.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        topObstacle.position = CGPoint(
            x: frame.width + obstacleWidth / 2, y: randomY + gapHeight / 2)
        // Create the physics body with a center offset to match the anchor point
        topObstacle.physicsBody = SKPhysicsBody(
            rectangleOf: topObstacle.size,
            center: CGPoint(x: 0, y: topObstacle.size.height / 2)
        )
        topObstacle.physicsBody?.isDynamic = false
        topObstacle.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        addChild(topObstacle)

        // Score gate
        let scoreGateSize = CGSize(width: 3, height: frame.height * 2)
        let scoreGate = SKSpriteNode(color: .clear, size: scoreGateSize)
        scoreGate.position = CGPoint(x: frame.width + obstacleWidth / 2, y: 0)
        scoreGate.physicsBody = SKPhysicsBody(rectangleOf: scoreGateSize)
        scoreGate.physicsBody?.isDynamic = false
        scoreGate.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreGate.physicsBody?.contactTestBitMask = PhysicsCategory.player
        scoreGate.physicsBody?.collisionBitMask = 0
        addChild(scoreGate)

        // Define the move action (from right to left)
        let moveDistance = frame.width + obstacleWidth
        let moveDuration = TimeInterval(moveDistance / 100)
        let moveAction = SKAction.moveBy(
            x: -moveDistance, y: 0, duration: moveDuration)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        bottomObstacle.run(sequence)
        topObstacle.run(sequence)
        scoreGate.run(sequence)
    }

    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted {
            return // Don't do anything until gameStarted is true
        }
        
        if !gameOver {
            // Flap on tap
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 150))
            
            // Immediately set the player rotation to a small upward angle for a flap rotation
            let flapAngle: CGFloat = 0.3
            let rotateAction = SKAction.rotate(byAngle: flapAngle, duration: 0.5)
            player.run(rotateAction)
        }
    }

    // MARK: - Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        // Determine which body is the player and which is the other
        let contactMask =
            contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if contactMask & PhysicsCategory.score != 0 && !gameOver {
            score += 1
            scoreLabel.text = "\(score)"

            // Remove the score gate so it only counts once
            if contact.bodyA.categoryBitMask == PhysicsCategory.score {
                contact.bodyA.node?.removeFromParent()
            } else if contact.bodyB.categoryBitMask == PhysicsCategory.score {
                contact.bodyB.node?.removeFromParent()
            }
        } else if contactMask
            & (PhysicsCategory.obstacle | PhysicsCategory.ground) != 0
        {
            // Player hit an obstacle or the ground -> game over
            if !gameOver {
                gameOver = true
                removeAction(forKey: "spawning")
                // Stop all node movement
                enumerateChildNodes(withName: "//*") { node, _ in
                    node.removeAllActions()
                }
                // TODO: Game Over modal
            }
        }
    }

    // MARK: - Update Loop
    override func update(_ currentTime: TimeInterval) {
        if !gameOver {
            guard let velocity = player.physicsBody?.velocity else { return }
                    let maxUpRotation: CGFloat = 0.3
                    let maxDownRotation: CGFloat = -0.3
                    let normalized = (velocity.dy + 150) / 300  // normalized between 0 and 1
                    let desiredAngle = maxDownRotation + normalized * (maxUpRotation - maxDownRotation)
                    
                    // Smoothly nose-dive the triangle boy
                    let rotationSpeed: CGFloat = 0.1
                    player.zRotation = player.zRotation + rotationSpeed * (desiredAngle - player.zRotation)
        }
    }
}
