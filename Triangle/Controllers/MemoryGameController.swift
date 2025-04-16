//
//  MemoryGameController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 28.03.2025.
//

import SwiftUI

class MemoryGameController: ObservableObject {
    @Published private(set) var gameModel: MemoryGameModel
    @Published private(set) var isGameReady = false
    private var indexOfFirstFaceUpCard: Int?
    private var userDataStore: UserDataStore
    
    init() {
        self.userDataStore = UserDataStore.shared
        // Initialize with an empty model then start level 1
        self.gameModel = MemoryGameModel(cards: [], level: 1)
        startLevel(1)
    }
    
    private func getRandomCosmeticPair(usedCombinations: Set<String>) -> (head: HeadCosmetic, eye: EyeCosmetic)? {
        guard let catalog = userDataStore.cosmeticCatalog else {
            print("No cosmetic catalog loaded.")
            return nil
        }
        
        // Get random head cosmetic (excluding "none")
        let availableHeadCosmetics = catalog.headCosmetics.filter { $0.cosmeticId != 1 }
        if availableHeadCosmetics.isEmpty {
            print("No available head cosmetics found.")
            return nil
        }
        
        // Get random eye cosmetic (excluding "none")
        let availableEyeCosmetics = catalog.eyeCosmetics.filter { $0.cosmeticId != 1 }
        if availableEyeCosmetics.isEmpty {
            print("No available eye cosmetics found.")
            return nil
        }
        
        // Try to find a unique combination
        var attempts = 0
        let maxAttempts = 10 // Prevent infinite recursion
        
        while attempts < maxAttempts {
            guard let headCosmetic = availableHeadCosmetics.randomElement(),
                  let eyeCosmetic = availableEyeCosmetics.randomElement() else {
                attempts += 1
                continue
            }
            
            // Create a unique identifier for this combination
            let combinationId = "\(headCosmetic.cosmeticId)_\(eyeCosmetic.cosmeticId)"
            
            // If this combination hasn't been used before, return it
            if !usedCombinations.contains(combinationId) {
                return (head: headCosmetic, eye: eyeCosmetic)
            }
            
            attempts += 1
        }
        
        print("Could not find a unique combination after \(maxAttempts) attempts.")
        return nil
    }
    
    func startLevel(_ level: Int) {
        let numberOfPairs = calculateNumberOfPairs(for: level)
        var cardArray: [MemoryCard] = []
        var usedCombinations = Set<String>()
        
        // Create pairs of cards with unique character data
        for _ in 0..<numberOfPairs {
            guard let cosmeticPair = getRandomCosmeticPair(usedCombinations: usedCombinations) else {
                print("Failed to get random cosmetic pair")
                continue
            }
            
            // Record this combination as used
            let combinationId = "\(cosmeticPair.head.cosmeticId)_\(cosmeticPair.eye.cosmeticId)"
            usedCombinations.insert(combinationId)
            
            let characterData = CharacterData(
                eyeCosmetic: cosmeticPair.eye,
                headCosmetic: cosmeticPair.head,
                colorId: 1
            )
            
            let card1 = MemoryCard(characterData: characterData, isFaceUp: true)
            let card2 = MemoryCard(characterData: characterData, isFaceUp: true)
            cardArray.append(contentsOf: [card1, card2])
        }
        
        // Shuffle the cards and update the game model
        cardArray.shuffle()
        self.gameModel = MemoryGameModel(cards: cardArray, level: level)
        indexOfFirstFaceUpCard = nil
        isGameReady = false
        
        // Flip cards face down after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            var cardsAfterDelay = self.gameModel.cards
            for i in 0..<cardsAfterDelay.count {
                cardsAfterDelay[i].isFaceUp = false
            }
            var updatedModel = self.gameModel
            updatedModel.cards = cardsAfterDelay
            self.gameModel = updatedModel
            self.isGameReady = true
        }
    }
    
    private func calculateNumberOfPairs(for level: Int) -> Int {
        // Level 1-3: 2x2 (2 pairs), Level 4-6: 4x4 (8 pairs), Level 7-9: 6x6 (18 pairs)
        let gridSize = ((level - 1) / 3) * 2 + 2
        return (gridSize * gridSize) / 2
    }
    
    func getGridSize() -> (rows: Int, cols: Int) {
        let gridSize = ((gameModel.level - 1) / 3) * 2 + 2
        return (rows: gridSize, cols: gridSize)
    }
    
    func flipCard(at index: Int) {
        guard isGameReady else { return }
        guard index >= 0 && index < gameModel.cards.count else { return }
        guard !gameModel.cards[index].isMatched && !gameModel.cards[index].isFaceUp else { return }
        
        // Make a mutable copy of the cards array
        var updatedCards = gameModel.cards
        
        if let firstIndex = indexOfFirstFaceUpCard {
            // Second card: flip it immediately
            var cardToUpdate = updatedCards[index]
            cardToUpdate.isFaceUp = true
            updatedCards[index] = cardToUpdate
            
            // Update moves count
            var updatedModel = gameModel
            updatedModel.moves += 1
            updatedModel.cards = updatedCards
            self.gameModel = updatedModel
            
            checkForMatch(index1: firstIndex, index2: index)
            indexOfFirstFaceUpCard = nil
        } else {
            // First card: flip and record its index
            var cardToUpdate = updatedCards[index]
            cardToUpdate.isFaceUp = true
            updatedCards[index] = cardToUpdate
            
            indexOfFirstFaceUpCard = index
            var updatedModel = gameModel
            updatedModel.cards = updatedCards
            self.gameModel = updatedModel
        }
    }
    
    private func checkForMatch(index1: Int, index2: Int) {
        var updatedCards = gameModel.cards
        
        // Compare character data for matching
        if updatedCards[index1].characterData == updatedCards[index2].characterData {
            // Match found - mark cards as matched after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                var cardsAfterMatch = self.gameModel.cards
                cardsAfterMatch[index1].isMatched = true
                cardsAfterMatch[index2].isMatched = true
                var updatedModel = self.gameModel
                updatedModel.cards = cardsAfterMatch
                self.gameModel = updatedModel
                
                // Check if game is complete
                if cardsAfterMatch.allSatisfy({ $0.isMatched }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.goToNextLevel()
                    }
                }
            }
        } else {
            // Not a match: flip them back down after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                var cardsAfterMismatch = self.gameModel.cards
                cardsAfterMismatch[index1].isFaceUp = false
                cardsAfterMismatch[index2].isFaceUp = false
                var updatedModel = self.gameModel
                updatedModel.cards = cardsAfterMismatch
                self.gameModel = updatedModel
            }
        }
    }
    
    private func goToNextLevel() {
        let nextLevel = gameModel.level + 1
        startLevel(nextLevel)
    }
    
    func restartCurrentLevel() {
        startLevel(gameModel.level)
    }
} 
