//
//  Cosmetic.swift
//  Triangle
//
//  Created by Josef Zemlicka on 12.03.2025.
//

import SwiftUI

enum CosmeticType: String, Codable {
    case eye
    case head
}

protocol Cosmetic: Codable, Equatable {
    var cosmeticId: Int { get }
    var assetName: String { get }
    var cosmeticTitle: String { get }
    var relativeScale: CGFloat { get }
    var offsetXRatio: CGFloat { get }
    var offsetYRatio: CGFloat { get }
    var rotation: CGFloat { get }
    var price: Int { get }
    var uniqueId: String { get }
}
