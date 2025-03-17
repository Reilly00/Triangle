//
//  UserData.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation


struct UserData: Codable, Equatable {
    var settings: SettingsData
    var progress: ProgressData
    var inventory: InventoryData
    var character: CharacterData

    // Encode for CloudKit storage
    func encodeToData() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    // Decode from CloudKit storage
    static func decodeFromData(_ data: Data) -> UserData? {
        return try? JSONDecoder().decode(UserData.self, from: data)
    }


    func prettyPrint() {
        let jsonData = try! JSONEncoder().encode(self)
        let jsonString = String(data: jsonData, encoding: .utf8) ?? "Error converting to JSON string"
        print(jsonString)
    }
}
