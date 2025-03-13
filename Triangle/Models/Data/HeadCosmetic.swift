//
//  HeadCosmetic.swift
//  Triangle
//
//  Created by Josef Zemlicka on 08.03.2025.
//

import SwiftUI

struct HeadCosmetic: Codable, Equatable {
    var cosmeticId: Int
    var assetName: String
    var relativeScale: CGFloat   // Now a relative value (e.g., 0.3)
    var offsetXRatio: CGFloat    // Relative horizontal offset (percentage of width)
    var offsetYRatio: CGFloat    // Relative vertical offset (percentage of height)
    var rotation: CGFloat

    static let defaultCosmetic = HeadCosmetic(
        cosmeticId: 1,
        assetName: "hc_none",
        relativeScale: 0,
        offsetXRatio: 0,
        offsetYRatio: 0,
        rotation: 0
    )
}
