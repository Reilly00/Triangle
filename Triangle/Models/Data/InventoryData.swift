//
//  CustomizationData.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation

struct InventoryData: Codable, Equatable {
    var currency: Int
    var unlockedCosmetics: UnlockedCosmetics
}

struct UnlockedCosmetics: Codable, Equatable {
    var headCosmetics: [HeadCosmetic]
    var eyeCosmetics: [EyeCosmetic]
    
    static let defaultUnlockedCosmetics = UnlockedCosmetics(
        headCosmetics: [HeadCosmetic.defaultCosmetic],
        eyeCosmetics: [EyeCosmetic.defaultCosmetic]
    )
}

extension InventoryData {

    static let defaultInventory: InventoryData = InventoryData(
        currency: 1000,
        unlockedCosmetics: UnlockedCosmetics.defaultUnlockedCosmetics
    )

    mutating func addCurrency(_ amount: Int) {
        self.currency += amount
    }

    // Unlock an eye cosmetic.
    mutating func unlockEyeCosmetic(_ cosmetic: EyeCosmetic) {
        if !unlockedCosmetics.eyeCosmetics.contains(where: {
            $0.uniqueId == cosmetic.uniqueId
        }) {
            unlockedCosmetics.eyeCosmetics.append(cosmetic)
        }
    }

    // Unlock a head cosmetic.
    mutating func unlockHeadCosmetic(_ cosmetic: HeadCosmetic) {
        if !unlockedCosmetics.headCosmetics.contains(where: {
            $0.uniqueId == cosmetic.uniqueId
        }) {
            unlockedCosmetics.headCosmetics.append(cosmetic)
        }
    }

}
