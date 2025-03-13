//
//  CustomizationData.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation

struct InventoryData: Codable, Equatable {
    var currency: Int
    var unlockedCosmetics: [String]
}

extension InventoryData {
    
    static let defaultInventory: InventoryData = InventoryData(
        currency: 0,
        unlockedCosmetics: []
    )
    
    mutating func addCurrency(_ amount: Int) {
        self.currency += amount
    }
    
    mutating func unlockCosmetic(_ cosmeticId: String) {
        if !unlockedCosmetics.contains(cosmeticId) {
            self.unlockedCosmetics.append(cosmeticId)
        }
    }
    
    mutating func lockCosmetic(_ cosmeticId: String) {
        if let index = unlockedCosmetics.firstIndex(of: cosmeticId) {
            self.unlockedCosmetics.remove(at: index)
        }
    }
    
}
