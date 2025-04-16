//
//  HexagonView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

struct HexagonView: View {
    @State private var selectedLevelId: Int?
    let exerciseId: Int
    let currentLevelIndex: Int

    init(exerciseId: Int, currentLevelIndex: Int) {
        self.exerciseId = exerciseId
        self.currentLevelIndex = currentLevelIndex
    }

    var body: some View {
        if let selectedLevel = selectedLevelId {
            LevelView(exerciseId: exerciseId, levelId: selectedLevel)
        } else {
            LevelSelectorView(
                exerciseId:exerciseId,
                totalTriangles: 10)
        }
    }

    // MARK: - Create Hexagons Based on Input
    static func createHexagons(for count: Int, currentLevelIndex: Int)
        -> [Hexagon]
    {
        let neededHexagons = count / 4
        let remainingTriangles = count % 4

        var newHexagons: [Hexagon] = []
        for _ in 0..<neededHexagons {
            newHexagons.append(Hexagon(visibleCount: 4))
        }

        if remainingTriangles > 0 {
            newHexagons.append(Hexagon(visibleCount: remainingTriangles))
        }

        return newHexagons
    }
}
