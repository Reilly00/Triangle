//
//  EyeCosmetic.swift
//  Triangle
//
//  Created by Josef Zemlicka on 08.03.2025.
//

import SwiftUI

struct EyeCosmetic: Codable, Equatable {
    var cosmeticId: Int
    var assetName: String
    var relativeScale: CGFloat   // Relative scaling factor
    var offsetXRatio: CGFloat    // Relative horizontal offset
    var offsetYRatio: CGFloat    // Relative vertical offset

    static let defaultCosmetic = EyeCosmetic(
        cosmeticId: 1,
        assetName: "ec_none",
        relativeScale: 0,
        offsetXRatio: 0,
        offsetYRatio: 0
    )
}
