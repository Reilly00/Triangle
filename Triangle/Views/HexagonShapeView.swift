//
//  HexagonShape.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//
import SwiftUI

struct HexagonShape: View {
    let hexagon: Hexagon
    let hexIndex: Int
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

                let tapEvent: () -> Void =
                    globalIndex > currentLevelIndex
                    ? {}
                    : {
                        onLevelSelect(globalIndex)
                    }

                // Determine the correct color for each triangle button
                // Hardcoded for now as the exercises are hardcoded
                let triangleColor: Color = {
                    if globalIndex == 7 || globalIndex == 8 {
                        return ColorTheme.lockedLevelColor
                    } else if globalIndex < currentLevelIndex {
                        return ColorTheme.completedLevelColor
                    } else if globalIndex == currentLevelIndex {
                        return ColorTheme.currentLevelColor
                    } else {
                        return ColorTheme.lockedLevelColor
                    }
                }()

                Button(action: {
                    if globalIndex == currentLevelIndex {
                        print("✅ Level \(globalIndex) selected - HexagonShapeView button action")
                        onLevelSelect(globalIndex)
                    } else if globalIndex < currentLevelIndex {
                        print(
                            "❌ Level \(globalIndex) is already completed and locked."
                        )
                    } else {
                        print("❌ Level \(globalIndex) is locked.")
                    }
                }) {
                    TriangleShape()
                        .fill(triangleColor)
                        .frame(width: size, height: size - 25)
                        .contentShape(TriangleShape())
                        .rotationEffect(rotations[triIndex])
                        .overlay(
                            Text("\(globalIndex)")
                                .font(.system(size: size * 0.3, weight: .bold))
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
