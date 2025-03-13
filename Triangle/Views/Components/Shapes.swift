//
//  Shapes.swift
//  Triangle
//
//  Created by Josef Zemlicka on 26.01.2025.
//

import SwiftUI

// Made with a tool I found online to convert the Triangle SVG to a SwiftUI Shape
// https://svg-to-swiftui.quassum.com/
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.37193 * width, y: 0.08145 * height))
        path.addCurve(
            to: CGPoint(x: 0.62708 * width, y: 0.08145 * height),
            control1: CGPoint(x: 0.42863 * width, y: -0.02715 * height),
            control2: CGPoint(x: 0.57038 * width, y: -0.02715 * height))
        path.addLine(to: CGPoint(x: 0.97905 * width, y: 0.75564 * height))
        path.addCurve(
            to: CGPoint(x: 0.85147 * width, y: height),
            control1: CGPoint(x: 1.03575 * width, y: 0.86424 * height),
            control2: CGPoint(x: 0.96487 * width, y: height))
        path.addLine(to: CGPoint(x: 0.14753 * width, y: height))
        path.addCurve(
            to: CGPoint(x: 0.01996 * width, y: 0.75564 * height),
            control1: CGPoint(x: 0.03413 * width, y: height),
            control2: CGPoint(x: -0.03674 * width, y: 0.86424 * height))
        path.addLine(to: CGPoint(x: 0.37193 * width, y: 0.08145 * height))
        path.closeSubpath()
        return path
    }
}
