//
//  UserDataStore.swift
//  Triangle
//
//  Created by Josef Zemlicka on 06.03.2025.
//

import SwiftUI

final class UserDataStore: ObservableObject {
    @Published var userData: UserData?
    @Published var cosmeticCatalog: CosmeticCatalog?
    @EnvironmentObject var authManager: AuthenticationManager
    private var userId: String

    init(userId: String) {
        self.userId = userId
        self.userData = nil
    }

    func updateUserId(_ newUserId: String) {
        self.userId = newUserId
        self.userData = loadUserData(for: userId)
        self.cosmeticCatalog = loadCosmeticCatalog()
        save()
    }

    /// Updates the settings and saves the data.
    func updateSettings(_ newSettings: SettingsData) {
        userData?.settings = newSettings
        save()
    }

    /// Convenience: Resets settings to the default values.
    func resetSettings() {
        updateSettings(SettingsData.defaultSettings)
    }

    /// Convenience: Updates the music volume.
    func updateMusicVolume(_ volume: Double) {
        var currentSettings = userData?.settings ?? SettingsData.defaultSettings
        currentSettings.musicVolume = volume
        updateSettings(currentSettings)
    }

    /// Convenience: Updates the SFX volume.
    func updateSFXVolume(_ volume: Double) {
        var currentSettings = userData?.settings ?? SettingsData.defaultSettings
        currentSettings.sfxVolume = volume
        updateSettings(currentSettings)
    }

    /// Convenience: Updates the text size.
    func updateTextSize(_ size: Double) {
        var currentSettings = userData?.settings ?? SettingsData.defaultSettings
        currentSettings.textSize = size
        updateSettings(currentSettings)
    }

    /// Convenience: Updates the selected language.
    func updateSelectedLanguage(_ language: String) {
        var currentSettings = userData?.settings ?? SettingsData.defaultSettings
        currentSettings.selectedLanguage = language
        updateSettings(currentSettings)
    }

    /// Updates the progress and saves the data.
    func updateProgress(_ newProgress: ProgressData) {
        userData?.progress = newProgress
        save()
    }

    func updateCharacter(_ newCharacter: CharacterData) {
        userData?.character = newCharacter
        save()
        print("Character updated: \(newCharacter)")
    }

    /// Loads the user data for a given username.
    /// - Parameter userId: The unique identifier for the user.
    /// - Returns: A UserData instance containing settings, progress, and customization data.
    func loadUserData(for userId: String) -> UserData {
        let key = userId
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let loadedUserData = try? decoder.decode(
                UserData.self, from: data)
            {
                return loadedUserData
            }
        }

        // Return default if no data exists
        let defaultSettings = SettingsData(
            musicVolume: 0.5, sfxVolume: 0.5, textSize: 1.0,
            selectedLanguage: "English")
        let defaultProgress = ProgressData()
        let defaultInventory = InventoryData(
            currency: 0, unlockedCosmetics: [])
        let defaultCharacter: CharacterData = .defaultCharacter
        return UserData(
            settings: defaultSettings, progress: defaultProgress,
            inventory: defaultInventory,
            character: defaultCharacter)
    }

    /// Saves the user data for a given user identifier.
    /// - Parameters:
    ///   - userData: The UserData instance to save.
    ///   - userId: The unique identifier for the user.
    func saveUserData(_ userData: UserData, for userId: String) {
        let key = userId
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(userData) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    /// Updates the customization data and saves the data.
    func updateInventory(_ newInventory: InventoryData) {
        userData?.inventory = newInventory
        save()
    }

    func levelCompleted(forExerciseId exerciseId: Int, levelId: Int) {
        guard var currentData = userData else { return }
        var newProgress = currentData.progress

        // Locate or create the exercise
        if let index = newProgress.exerciseProgresses.firstIndex(where: {
            $0.exerciseId == exerciseId
        }) {
            newProgress.exerciseProgresses[index].completeLevel(
                levelId: levelId)
        } else {
            // Create a new exercise record
            let newExercise = ExerciseProgress(
                exerciseId: exerciseId,
                currentLevelId: levelId + 1,
                levels: [
                    Level(
                        levelId: levelId, completed: true, currency: 0,
                        experience: 0)
                ]
            )
            newProgress.exerciseProgresses.append(newExercise)
        }

        print("Level \(levelId) completed for exercise \(exerciseId)")
        print(
            "New progress \(String(describing: userData?.progress.prettyPrint()))"
        )

        // Save it back
        currentData.progress = newProgress
        userData = currentData
        save()
    }

    /// Unlocks the next level for a given exercise.
    /// - Parameters:
    ///   - exerciseId: The identifier for the exercise.
    ///   - currentLevel: The current (completed) level.
    ///   - totalLevels: The total number of levels available for this exercise.
    func unlockNextLevel(
        forExerciseId exerciseId: Int, totalLevels: Int
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let currentLevel = self.getCurrentLevel(exerciseId: exerciseId)

            // Mark the current level as completed.
            self.levelCompleted(
                forExerciseId: exerciseId, levelId: currentLevel)

            if currentLevel < totalLevels {
                print(
                    "✅ Unlocking Level \(currentLevel + 1) of exercise \(exerciseId)"
                )
                print(
                    "New progress: \(String(describing: self.userData?.progress.description))"
                )
            } else {
                print("✅ All levels completed!")
            }
        }
    }

    func getCurrentLevel(exerciseId: Int) -> Int {
        if let progress = userData?.progress,
            let exerciseProgress = progress.exerciseProgresses.first(where: {
                $0.exerciseId == exerciseId
            })
        {
            return exerciseProgress.currentLevelId
        }
        return 1
    }

    /// Saves the current userData to persistent storage.
    private func save() {
        guard let userData = userData else { return }
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(userData) {
            UserDefaults.standard.set(data, forKey: userId)
        }
        print("UserData saved for user \(userId)")
        if let savedData = UserDefaults.standard.object(forKey: userId) {
            print("New settings: \(userData.settings)")
        }
    }

    func logout() {
        self.userData = nil
        self.cosmeticCatalog = nil
        // Do not clear persistent data from UserDefaults!!!!!
        print(
            "UserDataStore: User data cleared from memory, persistent data remains."
        )
    }
}
