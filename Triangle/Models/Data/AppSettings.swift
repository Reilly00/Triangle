//
//  AppSettings.swift
//  Triangle
//
//  Created by Josef Zemlicka on 06.03.2025.
//

import SwiftUI

final class AppSettings: ObservableObject, Codable {
    @Published var textSize: Double = 1.0
    @Published var musicVolume: Double = 0.5
    @Published var sfxVolume: Double = 0.5
    @Published var selectedLanguage: String = "English"

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case textSize, musicVolume, sfxVolume, selectedLanguage
    }

    init() { }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        textSize = try container.decode(Double.self, forKey: .textSize)
        musicVolume = try container.decode(Double.self, forKey: .musicVolume)
        sfxVolume = try container.decode(Double.self, forKey: .sfxVolume)
        selectedLanguage = try container.decode(String.self, forKey: .selectedLanguage)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(textSize, forKey: .textSize)
        try container.encode(musicVolume, forKey: .musicVolume)
        try container.encode(sfxVolume, forKey: .sfxVolume)
        try container.encode(selectedLanguage, forKey: .selectedLanguage)
    }
}

