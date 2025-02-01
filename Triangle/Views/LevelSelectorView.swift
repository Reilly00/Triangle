//
//  ExerciseSelectorView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 25.01.2025.
//

import SwiftUI

// MARK: - LevelSelectorView
struct LevelSelectorView: View {
    let totalTriangles: Int
    @Binding var selectedLevelId: Int?
    @State private var hexagons: [Hexagon] = []
    @State private var currentLevelIndex: Int

    init(
        totalTriangles: Int, currentLevelIndex: Int,
        selectedLevelId: Binding<Int?>
    ) {
        self.totalTriangles = totalTriangles
        self._currentLevelIndex = State(initialValue: currentLevelIndex)
        self._selectedLevelId = selectedLevelId
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.3
            let requiredHeight = max(
                CGFloat(hexagons.count) * size * 2.4, geometry.size.height * 1.7
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ZStack {
                        ForEach(hexagons.indices, id: \.self) { hexIndex in
                            HexagonShape(
                                hexagon: hexagons[hexIndex],
                                hexIndex: hexIndex,
                                size: size,
                                offsetY: -CGFloat(hexIndex) * (size * 2.4),
                                currentLevelIndex: $currentLevelIndex,
                                onLevelSelect: { levelId in
                                    selectedLevelId = levelId
                                },
                                isClockwise: hexIndex.isMultiple(of: 2)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .rotationEffect(Angle(degrees: 180))
                    Spacer(minLength: requiredHeight)
                }
                .frame(maxWidth: .infinity, minHeight: requiredHeight)
            }
            .rotationEffect(Angle(degrees: 180))
            .onAppear {
                hexagons = HexagonView.createHexagons(
                    for: totalTriangles, currentLevelIndex: currentLevelIndex)
            }
        }
        .background(Color(ColorTheme.background))
        .ignoresSafeArea()
    }
}

// MARK: - Main HexagonView
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
                totalTriangles: 10, currentLevelIndex: currentLevelIndex,
                selectedLevelId: $selectedLevelId)
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

// MARK: - Hexagon Shape with Proper Button Rendering
struct HexagonShape: View {
    let hexagon: Hexagon
    let hexIndex: Int  // Track hexagon index
    let size: CGFloat
    let offsetY: CGFloat
    @Binding var currentLevelIndex: Int
    let onLevelSelect: (Int) -> Void
    let isClockwise: Bool

    // Positions for clockwise and counterclockwise rotations
    let positionsClockwise: [CGPoint] = [
        CGPoint(x: 0, y: -0.1),
        CGPoint(x: 0.7, y: -0.5),
        CGPoint(x: 0.7, y: -1.15),
        CGPoint(x: 0, y: -1.55),
    ]

    let positionsCounterclockwise: [CGPoint] = [
        CGPoint(x: 0, y: -0.1),
        CGPoint(x: -0.7, y: -0.5),
        CGPoint(x: -0.7, y: -1.15),
        CGPoint(x: 0, y: -1.55),
    ]

    let rotationsClockwise: [Angle] = [
        .degrees(0), .degrees(60), .degrees(120), .degrees(180),
    ]

    let rotationsCounterclockwise: [Angle] = [
        .degrees(0), .degrees(-60), .degrees(-120), .degrees(180),
    ]

    var body: some View {
        let positions =
            isClockwise ? positionsClockwise : positionsCounterclockwise
        let rotations =
            isClockwise ? rotationsClockwise : rotationsCounterclockwise

        ZStack {
            ForEach(0..<hexagon.visibleCount, id: \.self) { triIndex in
                let globalIndex = (hexIndex * 4) + triIndex + 1

                // Set imageName conditionally based on globalIndex and currentLevelIndex
                let tapEvent: () -> Void =
                    globalIndex > currentLevelIndex
                    ? {}
                    : {
                        onLevelSelect(globalIndex)
                    }

                // Determine the correct color for each triangle button
                let triangleColor: Color = {
                    if globalIndex < currentLevelIndex {
                        return ColorTheme.green  // Completed levels
                    } else if globalIndex == currentLevelIndex {
                        return ColorTheme.primary  // Current level
                    } else {
                        return ColorTheme.darker  // Locked levels
                    }
                }()

                
                Button(action: {
                    print("Triangle button tapped! " + globalIndex.description)
                    tapEvent()
                }) {
                    TriangleShape()
                        .fill(triangleColor)
                        .frame(width: size, height: size - 25)
                        .contentShape(TriangleShape())
                        .rotationEffect(rotations[triIndex])
                        .overlay(
                            Text("\(globalIndex)")
                                .font(
                                    .system(size: size * 0.3, weight: .bold)
                                )
                                .foregroundColor(Color.white)
                        )
                }
                .offset(
                    x: positions[triIndex].x * size,
                    y: (positions[triIndex].y * size) + offsetY
                )
            }
        }
    }
}

// MARK: - LevelView
struct LevelView: View {
    let exerciseId: Int
    let levelId: Int

    var body: some View {
        VStack {
            Text("Exercise \(exerciseId) - Level \(levelId)")
                .font(.largeTitle)
            // Add other UI elements related to the level here
        }
        .navigationBarHidden(true)  // Hides the navigation bar on the LevelView
    }
}

// MARK: - Hexagon Data Model
struct Hexagon {
    var visibleCount: Int = 0
}

struct ContentView: View {
    var body: some View {
        HexagonView(exerciseId: 1, currentLevelIndex: 3)  // Example dynamic values
    }
}

struct LevelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
