//
//  Navbar.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct HalfCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Arc from left to right across the bottom of the rect
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Close off the shape at the bottom
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

struct TopArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Start from the bottom-left corner
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        // Curve up to the bottom-right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        path.closeSubpath()
        return path
    }
}

struct Navbar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            HalfCircleShape()
                .fill(.ultraThinMaterial)
                .shadow(radius: 5)
                .frame(width: 350, height: 130)
                .offset(y: 20)// Adjust as needed

            VStack(spacing: 16) {
                HStack(spacing: -20) {
                    // Leaderboard Button
                    Button(action: { selectedTab = .leaderboard }) {
                        ZStack {
                            TriangleShape()
                                .fill(
                                    selectedTab == .leaderboard
                                        ? ColorTheme.accent : ColorTheme.text
                                )
                                .frame(width: 110, height: 100)
                                .offset(y: 4)

                            TriangleShape()
                                .fill(
                                    selectedTab == .leaderboard
                                        ? ColorTheme.secondary
                                        : ColorTheme.primary
                                )
                                .frame(width: 110, height: 100)
                                .rotationEffect(.degrees(0))

                            Image(systemName: Tab.leaderboard.icon)
                                .font(.system(size: 100 * 0.4))
                                .foregroundColor(
                                    selectedTab == .leaderboard
                                        ? ColorTheme.text
                                        : ColorTheme.background
                                )
                                .shadow(radius: 2, x: 0, y: 4)
                                .offset(x: 0, y: 100 * 0.1)
                        }
                    }

                    // Dashboard Button
                    Button(action: { selectedTab = .dashboard }) {
                        ZStack {
                            TriangleShape()
                                .fill(
                                    selectedTab == .dashboard
                                        ? ColorTheme.accent : ColorTheme.text
                                )
                                .frame(width: 130, height: 120)
                                .rotationEffect(.degrees(180))
                                .offset(y: 5)

                            TriangleShape()
                                .fill(
                                    selectedTab == .dashboard
                                        ? ColorTheme.secondary
                                        : ColorTheme.primary
                                )
                                .frame(width: 130, height: 120)
                                .rotationEffect(.degrees(180))

                            Image(systemName: Tab.dashboard.icon)
                                .font(.system(size: 120 * 0.4))
                                .foregroundColor(
                                    selectedTab == .dashboard
                                        ? ColorTheme.text
                                        : ColorTheme.background
                                )
                                .shadow(radius: 2, x: 0, y: 4)
                                .offset(x: 0, y: 120 * -0.15)
                        }
                    }
                    .offset(y: -15)

                    // Profile Button
                    Button(action: { selectedTab = .profile }) {
                        ZStack {
                            TriangleShape()
                                .fill(
                                    selectedTab == .profile
                                        ? ColorTheme.accent : ColorTheme.text
                                )
                                .frame(width: 110, height: 100)
                                .offset(y: 4)

                            TriangleShape()
                                .fill(
                                    selectedTab == .profile
                                        ? ColorTheme.secondary
                                        : ColorTheme.primary
                                )
                                .frame(width: 110, height: 100)
                                .rotationEffect(.degrees(0))

                            Image(systemName: Tab.profile.icon)
                                .font(.system(size: 100 * 0.4))
                                .foregroundColor(
                                    selectedTab == .profile
                                        ? ColorTheme.text
                                        : ColorTheme.background
                                )
                                .shadow(radius: 2, x: 0, y: 4)
                                .offset(x: 0, y: 100 * 0.1)
                        }
                    }
                }
                .offset(y: 15)
            }
        }
        .offset(y: 15)
        .frame(width: 400, height: 200)
    }
}

#Preview {
    Navbar(selectedTab: .constant(.profile))
}
