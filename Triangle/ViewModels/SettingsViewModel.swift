//
//  SettingsViewModel.swift
//  Triangle
//
//  Created by Josef Zemlicka on 20.02.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var musicVolume: Double {
        didSet { saveSetting(value: musicVolume, key: "musicVolume") }
    }
    @Published var sfxVolume: Double {
        didSet { saveSetting(value: sfxVolume, key: "sfxVolume") }
    }
    @Published var masterVolume: Double {
        didSet { saveSetting(value: masterVolume, key: "masterVolume") }
    }
    @Published var textSize: Double {
        didSet { saveSetting(value: textSize, key: "textSize") }
    }
    @Published var selectedLanguage: String {
        didSet { saveSetting(value: selectedLanguage, key: "selectedLanguage") }
    }
    @Published var musicVolumeOn: Bool {
        didSet { saveSetting(value: musicVolumeOn, key: "musicVolumeOn") }
    }
    @Published var highContrastMode: Bool {
        didSet { saveSetting(value: highContrastMode, key: "highContrastMode") }
    }
    @Published var reducedAnimations: Bool {
        didSet { saveSetting(value: highContrastMode, key: "highContrastMode") }
    }
    @Published var colorBlindMode: String {
            didSet { UserDefaults.standard.set(colorBlindMode, forKey: "colorBlindMode") }
    }

    
    let languages = ["English", "Czech", "Spanish"]

    init() {
        // Initialize with default values first
        let defaultMusicVolume: Double = 0.5
        let defaultSfxVolume: Double = 0.5
        let defaultMasterVolume: Double = 1.0
        let defaultTextSize: Double = 1.0
        let defaultLanguage: String = "English"
        let defaultMusicVolumeOn: Bool = true
        let defaultHighContrastMode: Bool = false
        let defaultReducedAnimations: Bool = false
        let defaultColorBlindMode: String = "none"
        
        

        
        self.musicVolume = UserDefaults.standard.object(forKey: "musicVolume") as? Double ?? defaultMusicVolume
        self.sfxVolume = UserDefaults.standard.object(forKey: "sfxVolume") as? Double ?? defaultSfxVolume
        self.masterVolume = UserDefaults.standard.object(forKey: "masterVolume") as? Double ?? defaultMasterVolume
        self.textSize = UserDefaults.standard.object(forKey: "textSize") as? Double ?? defaultTextSize
        self.selectedLanguage = UserDefaults.standard.object(forKey: "selectedLanguage") as? String ?? defaultLanguage
        self.musicVolumeOn = UserDefaults.standard.object(forKey: "musicVolumeOn") as? Bool ?? defaultMusicVolumeOn
        self.highContrastMode = UserDefaults.standard.object(forKey: "highContrastMode") as? Bool ?? defaultHighContrastMode
        self.reducedAnimations = UserDefaults.standard.object(forKey: "reducedAnimations") as? Bool ?? defaultReducedAnimations
        self.colorBlindMode = UserDefaults.standard.object(forKey: "colorBlindMode") as? String ?? defaultColorBlindMode
    }

    private func saveSetting<T>(value: T, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    private func loadSetting<T>(for key: String, defaultValue: T) -> T {
        return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
}


