//
//  UserDataStore.swift
//  Triangle
//
//  Created by Josef Zemlicka on 06.03.2025.
//  Updated by Ciaran Mullen on 16.03.2025
//

import SwiftUI

final class UserDataStore: ObservableObject {
    @Published var userData: UserData?
    @Published var cosmeticCatalog: CosmeticCatalog?
    private var userId: String

    init(userId: String) {
        self.userId = userId
        self.userData = loadUserData(for: userId) // Load from local storage first
        self.cosmeticCatalog = loadCosmeticCatalog()
    }

    func updateUserId(_ newUserId: String) {
        self.userId = newUserId
        self.userData = loadUserData(for: userId)
        self.cosmeticCatalog = loadCosmeticCatalog()
        save()
    }

    /// Loads user data, prioritizing local storage and falling back to CloudKit
       func loadUserData(for userId: String) -> UserData? {
           if let data = UserDefaults.standard.data(forKey: userId),
              let localUserData = try? JSONDecoder().decode(UserData.self, from: data) {
               print("✅ Loaded UserData from local storage for \(userId)")
               return localUserData
           }

           // If no local data, fetch from CloudKit
           CloudKitManager.shared.loadUserData(username: userId) { [weak self] userData, error in
               guard let self = self else { return }
               if let userData = userData {
                   DispatchQueue.main.async {
                       self.userData = userData
                       self.save() // Store it locally for future use
                       print("✅ UserData loaded from CloudKit for \(userId)")
                   }
               } else {
                   print("⚠️ No UserData found in CloudKit for \(userId)")
               }
           }
           
           return nil // Return nil if no local data is available while CloudKit fetch runs
       }


    /// Saves user data to both local storage and CloudKit
    func save() {
        guard let userData = userData else { return }
        let encoder = JSONEncoder()

        // Save to UserDefaults
        if let data = try? encoder.encode(userData) {
            UserDefaults.standard.set(data, forKey: userId)
            print("✅ UserData saved locally for user \(userId)")
        }

        // Save to CloudKit
        CloudKitManager.shared.saveUserData(username: userId, userData: userData) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("✅ UserData successfully saved to CloudKit")
                } else {
                    print("❌ Failed to save UserData to CloudKit: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    /// Updates the inventory and ensures changes are saved
      func updateInventory(_ newInventory: InventoryData) {
          userData?.inventory = newInventory
          save()
      }

      /// Ensures currency updates persist across app restarts
      func addCurrency(amount: Int) {
          if var inventory = userData?.inventory {
              inventory.addCurrency(amount)
              updateInventory(inventory) // Save changes
          }
      }
    
    /// Handles cosmetic purchases and persists them
    func buyCosmetic(_ cosmetic: any Cosmetic) {
        guard var inventory = userData?.inventory else {
            print("⚠️ User inventory is not available.")
            return
        }

        // Check if the cosmetic is already owned
        if let headCosmetic = cosmetic as? HeadCosmetic {
            if inventory.unlockedCosmetics.headCosmetics.contains(where: { $0.uniqueId == headCosmetic.uniqueId }) {
                print("⚠️ Head cosmetic '\(headCosmetic.cosmeticTitle)' is already unlocked.")
                return
            }
        } else if let eyeCosmetic = cosmetic as? EyeCosmetic {
            if inventory.unlockedCosmetics.eyeCosmetics.contains(where: { $0.uniqueId == eyeCosmetic.uniqueId }) {
                print("⚠️ Eye cosmetic '\(eyeCosmetic.cosmeticTitle)' is already unlocked.")
                return
            }
        } else {
            print("⚠️ Unsupported cosmetic type.")
            return
        }

        // Deduct currency and add the cosmetic
        let price = cosmetic.price
        if inventory.currency < price {
            print("❌ Not enough currency to purchase \(cosmetic.cosmeticTitle).")
            return
        }

        inventory.currency -= price
        if let headCosmetic = cosmetic as? HeadCosmetic {
            inventory.unlockedCosmetics.headCosmetics.append(headCosmetic)
        } else if let eyeCosmetic = cosmetic as? EyeCosmetic {
            inventory.unlockedCosmetics.eyeCosmetics.append(eyeCosmetic)
        }

        // Save updates to both CloudKit and local storage
        updateInventory(inventory)
        print("✅ Purchased \(cosmetic.cosmeticTitle)")
    }
    /// Retrieves unique cosmetics for shop display
    func getRandomCosmetics(count: Int = 4) -> [any Cosmetic] {
        guard let catalog = cosmeticCatalog else {
            print("⚠️ No cosmetic catalog loaded.")
            return []
        }

        // Explicitly cast both arrays to `[any Cosmetic]`
        let allCosmetics: [any Cosmetic] = catalog.headCosmetics as [any Cosmetic] + catalog.eyeCosmetics as [any Cosmetic]

        let shuffled = allCosmetics.shuffled()
        return Array(shuffled.prefix(count))
    }

    

    
    /// Updates the settings and saves the data.
    func updateSettings(_ newSettings: SettingsData) {
        guard userData?.settings != newSettings else { return }
        userData?.settings = newSettings
        save()
    }

    /// Convenience: Resets settings to the default values.
    func resetSettings() {
        updateSettings(SettingsData.defaultSettings)
    }

    /// Convenience: Updates various user settings.
    func updateMusicVolume(_ volume: Double) {
        var settings = userData?.settings ?? SettingsData.defaultSettings
        settings.musicVolume = volume
        updateSettings(settings)
    }

    func updateSFXVolume(_ volume: Double) {
        var settings = userData?.settings ?? SettingsData.defaultSettings
        settings.sfxVolume = volume
        updateSettings(settings)
    }

    func updateTextSize(_ size: Double) {
        var settings = userData?.settings ?? SettingsData.defaultSettings
        settings.textSize = size
        updateSettings(settings)
    }

    func updateSelectedLanguage(_ language: String) {
        var settings = userData?.settings ?? SettingsData.defaultSettings
        settings.selectedLanguage = language
        updateSettings(settings)
    }

    /// Updates the progress and saves the data.
    func updateProgress(_ newProgress: ProgressData) {
        guard userData?.progress != newProgress else { return }
        userData?.progress = newProgress
        save()
    }

    func updateCharacter(_ newCharacter: CharacterData) {
        guard userData?.character != newCharacter else { return }
        userData?.character = newCharacter
        save()
    }

    /// Unlocks the next level for a given exercise.
    func unlockNextLevel(forExerciseId exerciseId: Int, totalLevels: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let currentLevel = self.getCurrentLevel(exerciseId: exerciseId)

         //   self.levelCompleted(forExerciseId: exerciseId, levelId: currentLevel)

            if currentLevel < totalLevels {
                print("✅ Unlocking Level \(currentLevel + 1) of exercise \(exerciseId)")
            } else {
                print("✅ All levels completed!")
            }
        }
    }

    func getCurrentLevel(exerciseId: Int) -> Int {
        if let progress = userData?.progress,
           let exerciseProgress = progress.exerciseProgresses.first(where: { $0.exerciseId == exerciseId }) {
            return exerciseProgress.currentLevelId
        }
        return 1
    }

    func logout() {
        self.userData = nil
        self.cosmeticCatalog = nil
        print("UserDataStore: User data cleared from memory, persistent data remains.")
    }

}
