//
//  HeadCosmetic.swift
//  Triangle
//
//  Created by Josef Zemlicka on 08.03.2025.
//

import SwiftUI

struct HeadCosmetic: Codable, Equatable, Cosmetic {
    var cosmeticId: Int
    var assetName: String
    var cosmeticTitle: String
    var relativeScale: CGFloat
    var offsetXRatio: CGFloat
    var offsetYRatio: CGFloat
    var rotation: CGFloat
    var price: Int

    var uniqueId: String {
        return "head_\(cosmeticId)"
    }

    static let defaultCosmetic = HeadCosmetic(
        cosmeticId: 1,
        assetName: "hc_none",
        cosmeticTitle: "None",
        relativeScale: 0,
        offsetXRatio: 0,
        offsetYRatio: 0,
        rotation: 0,
        price: 0
    )
}
