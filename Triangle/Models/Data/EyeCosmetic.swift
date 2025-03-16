//
//  EyeCosmetic.swift
//  Triangle
//
//  Created by Josef Zemlicka on 08.03.2025.
//

import SwiftUI

struct EyeCosmetic: Codable, Equatable, Cosmetic {
    var cosmeticId: Int
    var assetName: String
    var cosmeticTitle: String
    var relativeScale: CGFloat  // Relative scaling factor
    var offsetXRatio: CGFloat  // Relative horizontal offset
    var offsetYRatio: CGFloat  // Relative vertical offset
    var rotation: CGFloat
    var price: Int

    var uniqueId: String {
        return "eye_\(cosmeticId)"
    }

    static let defaultCosmetic = EyeCosmetic(
        cosmeticId: 1,
        assetName: "ec_none",
        cosmeticTitle: "None",
        relativeScale: 0,
        offsetXRatio: 0,
        offsetYRatio: 0,
        rotation: 0,
        price: 0
    )
}
