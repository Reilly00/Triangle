//
//  LevelSelectorController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class LevelSelectorController: ObservableObject {
    @Published var hexagons: [Hexagon] = []
    @Published var currentLevelIndex: Int
    @Published var selectedLevel: Int? = nil

    let totalTriangles: Int

    init(totalTriangles: Int, currentLevelIndex: Int) {
        self.totalTriangles = totalTriangles
        self.currentLevelIndex = currentLevelIndex
        self.hexagons = LevelSelectorController.createHexagons(for: totalTriangles, currentLevelIndex: currentLevelIndex)
        print("Initialized LevelSelectorController with totalTriangles: \(totalTriangles) and currentLevelIndex: \(currentLevelIndex)")
    }
    
    static func createHexagons(for count: Int, currentLevelIndex: Int) -> [Hexagon] {
        let neededHexagons = count / 4
        let remainingTriangles = count % 4
        
        var newHexagons: [Hexagon] = []
        for _ in 0..<neededHexagons {
            newHexagons.append(Hexagon(visibleCount: 4))
        }
        if remainingTriangles > 0 {
            newHexagons.append(Hexagon(visibleCount: remainingTriangles))
        }
        print("Created \(newHexagons.count) hexagons")
        return newHexagons
    }
    
    /// Called when a level is tapped.
    func selectLevel(levelId: Int) {
        print("selectLevel called with levelId: \(levelId), currentLevelIndex: \(currentLevelIndex)")
        if levelId <= currentLevelIndex {
            selectedLevel = levelId
            print("✅ Level \(levelId) selected. selectedLevel set to \(levelId)")
        } else {
            print("Level \(levelId) is locked or already completed.")
        }
    }
    
    /// Unlocks the next level if available.
    func unlockNextLevel() {
        print("unlockNextLevel called. Current level index: \(currentLevelIndex)")
        if currentLevelIndex < totalTriangles {
            currentLevelIndex += 1
            hexagons = LevelSelectorController.createHexagons(for: totalTriangles, currentLevelIndex: currentLevelIndex)
            print("Next level unlocked: \(currentLevelIndex)")
        } else {
            print("All levels completed!")
        }
    }
}
