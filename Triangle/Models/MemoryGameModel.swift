//
//  MemoryGameModel.swift
//  Triangle
//
//  Created by Josef Zemlicka on 28.03.2025.
//

import Foundation

// The Card model for our Memory Match game
struct MemoryCard: Identifiable {
    let id = UUID()
    let characterData: CharacterData
    var isFaceUp: Bool
    var isMatched: Bool = false
}

// The MemoryGameModel holds the current array of cards and game state
struct MemoryGameModel {
    var cards: [MemoryCard]
    var level: Int
    var moves: Int = 0
    var isGameComplete: Bool = false
} 
