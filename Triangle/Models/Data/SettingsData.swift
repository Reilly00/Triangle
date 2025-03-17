//
//  SettingsData.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation


struct SettingsData: Codable, Equatable {
    var musicVolume: Double
    var sfxVolume: Double
    var textSize: Double
    var selectedLanguage: String

    // Encode for CloudKit storage
    func encodeToData() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    // Decode from CloudKit storage
    static func decodeFromData(_ data: Data) -> SettingsData? {
        return try? JSONDecoder().decode(SettingsData.self, from: data)
    }
}


extension SettingsData {

    static let defaultSettings: SettingsData = SettingsData(
        musicVolume: 0.5,
        sfxVolume: 0.5,
        textSize: 1.0,
        selectedLanguage: "English"
    )

    mutating func updateMusicVolume(_ volume: Double) {
        self.musicVolume = max(0, min(1, volume))
    }

    mutating func updateSFXVolume(_ volume: Double) {
        self.sfxVolume = max(0, min(1, volume))
    }

    mutating func updateTextSize(_ size: Double) {
        self.textSize = max(0.5, min(2, size))
    }

    mutating func updateSelectedLanguage(_ language: String) {
        self.selectedLanguage = language
    }

    mutating func reset() {
        self = SettingsData.defaultSettings
    }
}
