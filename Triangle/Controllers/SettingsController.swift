//
//  SettingsController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class SettingsController: ObservableObject {
    private let userDataStore: UserDataStore

    // Provide the list of available languages.
    var languages: [String] {
        return ["English", "Czech", "Spanish"]
    }

    // Dependency injection via initializer.
    init(userDataStore: UserDataStore) {
        self.userDataStore = userDataStore
    }

    // MARK: - Updates

    func updateMusicVolume(_ volume: Double) {
        guard var currentSettings = userDataStore.userData?.settings else {
            return
        }
        currentSettings.updateMusicVolume(volume)
        userDataStore.updateSettings(currentSettings)
    }

    func updateSFXVolume(_ volume: Double) {
        guard var currentSettings = userDataStore.userData?.settings else {
            return
        }
        currentSettings.updateSFXVolume(volume)
        userDataStore.updateSettings(currentSettings)
    }

    func updateTextSize(_ size: Double) {
        guard var currentSettings = userDataStore.userData?.settings else {
            return
        }
        currentSettings.updateTextSize(size)
        userDataStore.updateSettings(currentSettings)
    }

    func updateLanguage(_ language: String) {
        guard var currentSettings = userDataStore.userData?.settings else {
            return
        }
        currentSettings.updateSelectedLanguage(language)
        userDataStore.updateSettings(currentSettings)
    }

    // MARK: - Reset Functions

    func resetSettings() {
        userDataStore.updateSettings(SettingsData.defaultSettings)
    }

    func resetProgress() {
        userDataStore.updateProgress(ProgressData())
    }
}
