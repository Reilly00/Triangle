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
    private var userId: String

    init(userId: String) {
        self.userId = userId
        self.userData = nil
        self.cosmeticCatalog = loadCosmeticCatalog()
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
        let defaultInventory = InventoryData.defaultInventory
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

    /// Returns up to 4 random unique cosmetic items from the entire catalog (head + eye).
    func getRandomCosmetics(count: Int = 4) -> [any Cosmetic] {
        // Ensure the catalog is loaded.
        guard let catalog = cosmeticCatalog else {
            print("No cosmetic catalog loaded.")
            return []
        }

        // Combine head and eye cosmetics into a single array.
        let allCosmetics: [any Cosmetic] =
            catalog.headCosmetics + catalog.eyeCosmetics

        // Initialize the set with the "none" cosmetics so that they are not being chosen
        var seenIds: Set<String> = ["eye_1", "head_1"]
        seenIds.insert("eye_1")
        seenIds.insert("head_1")
        let noDuplicates = allCosmetics.filter { cosmetic in
            let id = cosmetic.uniqueId
            if seenIds.contains(id) {
                return false
            } else {
                seenIds.insert(id)
                return true
            }
        }

        // Shuffle the filtered array so items are in random order.
        let shuffled = noDuplicates.shuffled()

        // Return up to the specified count.
        return Array(shuffled.prefix(count))
    }

    /// Attempts to purchase the given cosmetic.
    func buyCosmetic(_ cosmetic: any Cosmetic) {
        // Ensure that the user's inventory exists.
        guard var inventory = userData?.inventory else {
            print("User inventory is not available.")
            return
        }

        // Process a head cosmetic.
        if let headCosmetic = cosmetic as? HeadCosmetic {
            let price = headCosmetic.price

            // Check if already unlocked.
            if inventory.unlockedCosmetics.headCosmetics.contains(where: {
                $0.uniqueId == headCosmetic.uniqueId
            }) {
                print(
                    "Head cosmetic '\(headCosmetic.cosmeticTitle)' is already unlocked."
                )
                return
            }

            // Check currency.
            if inventory.currency < price {
                print(
                    "Not enough currency to purchase head cosmetic. Needed: \(price), available: \(inventory.currency)."
                )
                return
            }

            // Deduct currency and add the cosmetic.
            inventory.currency -= price
            inventory.unlockedCosmetics.headCosmetics.append(headCosmetic)
            updateInventory(inventory)
            print("Purchased head cosmetic: \(headCosmetic.cosmeticTitle)")

            // Process an eye cosmetic.
        } else if let eyeCosmetic = cosmetic as? EyeCosmetic {
            let price = eyeCosmetic.price

            // Check if already unlocked.
            if inventory.unlockedCosmetics.eyeCosmetics.contains(where: {
                $0.uniqueId == eyeCosmetic.uniqueId
            }) {
                print(
                    "Eye cosmetic '\(eyeCosmetic.cosmeticTitle)' is already unlocked."
                )
                return
            }

            // Check currency.
            if inventory.currency < price {
                print(
                    "Not enough currency to purchase eye cosmetic. Needed: \(price), available: \(inventory.currency)."
                )
                return
            }

            // Deduct currency and add the cosmetic.
            inventory.currency -= price
            inventory.unlockedCosmetics.eyeCosmetics.append(eyeCosmetic)
            updateInventory(inventory)
            print("Purchased eye cosmetic: \(eyeCosmetic.cosmeticTitle)")

        } else {
            print("Unsupported cosmetic type.")
            return
        }
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
