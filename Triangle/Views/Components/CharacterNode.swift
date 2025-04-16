//
//  CharacterNode.swift
//  Triangle
//
//  Created by Josef Zemlicka on 24.03.2025.
//

import SpriteKit

class CharacterNode: SKNode {
    private var baseNode: SKSpriteNode
    private var headNode: SKSpriteNode
    private var eyeNode: SKSpriteNode

    override init() {
        self.baseNode = SKSpriteNode()
        self.headNode = SKSpriteNode()
        self.eyeNode = SKSpriteNode()
        super.init()
        
        guard let characterData = UserDataStore.shared.userData?.character else {
            fatalError("Character data not found.")
        }
        
        let referenceFrameSize: CGFloat = 1200
        
        // Load base texture
        let baseTexture = SKTexture(imageNamed: "character_base")
        baseNode = SKSpriteNode(texture: baseTexture)
        baseNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Set base node size explicitly to the reference size
        baseNode.size = CGSize(width: referenceFrameSize, height: referenceFrameSize)

        // Load cosmetics textures
        let headTexture = SKTexture(imageNamed: characterData.headCosmetic.assetName)
        headNode = SKSpriteNode(texture: headTexture)
        headNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let eyeTexture = SKTexture(imageNamed: characterData.eyeCosmetic.assetName)
        eyeNode = SKSpriteNode(texture: eyeTexture)
        eyeNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        // Position and scale cosmetics relative to the reference size

        // HEAD COSMETIC
        headNode.zRotation = CGFloat(characterData.headCosmetic.rotation * .pi / 180)
        headNode.setScale(characterData.headCosmetic.relativeScale)
        headNode.position = CGPoint(
            x: referenceFrameSize * characterData.headCosmetic.offsetXRatio,
            y: referenceFrameSize * characterData.headCosmetic.offsetYRatio
        )

        // EYE COSMETIC
        eyeNode.setScale(characterData.eyeCosmetic.relativeScale)
        eyeNode.position = CGPoint(
            x: referenceFrameSize * characterData.eyeCosmetic.offsetXRatio,
            y: referenceFrameSize * characterData.eyeCosmetic.offsetYRatio
        )

        // Assemble the node hierarchy
        addChild(baseNode)
        // TODO: Fix the positioning of the cosmetics
//        baseNode.addChild(headNode)
//        baseNode.addChild(eyeNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Helper function to scale the entire node after initialization
    func scaleTo(size targetSize: CGFloat) {
        let referenceFrameSize: CGFloat = 500
        let finalScale = targetSize / referenceFrameSize
        self.setScale(finalScale)
    }
}
