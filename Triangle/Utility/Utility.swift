//
//  Utility.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//

import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

final class NavbarVisibility: ObservableObject {
    @Published var isVisible: Bool = true
    @Published var isBottomNavVisible: Bool = true
}
