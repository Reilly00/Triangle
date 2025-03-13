//
//  CosmeticCatalog.swift
//  Triangle
//
//  Created by Josef Zemlicka on 08.03.2025.
//

import SwiftUI

struct CosmeticCatalog: Codable {
    var headCosmetics: [HeadCosmetic]
    var eyeCosmetics: [EyeCosmetic]
}

func loadCosmeticCatalog() -> CosmeticCatalog? {
    guard
        let url = Bundle.main.url(
            forResource: "cosmetics", withExtension: "json")
    else {
        print("Cosmetics JSON file not found")
        return nil
    }
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let catalog = try decoder.decode(CosmeticCatalog.self, from: data)
        return catalog
    } catch {
        print("Error loading cosmetics: \(error)")
        return nil
    }
}
