//
//  InventoryView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 13.03.2025.
//

import SwiftUI

enum CosmeticTab: String, CaseIterable, Identifiable {
    case head = "Head Cosmetics"
    case eye = "Eye Cosmetics"

    var id: Self { self }
}

struct InventoryView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: CosmeticTab = .head
    @State private var characterData: CharacterData = CharacterData
        .defaultCharacter

    // 4 column grid setup
    let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Inventory", onBack: { dismiss() })

                // Character
                Character(characterData: characterData, useAnimations: true)
                    .frame(height: 400)
                    .padding()

                // Default picker for now
                // TODO: Custom picker style
                Picker("Cosmetics", selection: $selectedTab) {
                    ForEach(CosmeticTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 8)

                // Scrollable inventory
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 8) {
                        if selectedTab == .head {
                            ForEach(
                                userDataStore.userData?.inventory
                                    .unlockedCosmetics.headCosmetics ?? [],
                                id: \.uniqueId
                            ) { cosmetic in
                                CosmeticCell(
                                    cosmeticTitle: cosmetic.cosmeticTitle,
                                    assetName: cosmetic.assetName,
                                    isSelected: cosmetic.uniqueId
                                        == characterData.headCosmetic.uniqueId,
                                    onTap: {
                                        characterData.headCosmetic = cosmetic
                                        userDataStore.updateCharacter(
                                            characterData)
                                        print(
                                            "Updated head cosmetic to: \(cosmetic.cosmeticTitle)"
                                        )
                                    }
                                )
                            }
                        } else {
                            ForEach(
                                userDataStore.userData?.inventory
                                    .unlockedCosmetics.eyeCosmetics ?? [],
                                id: \.uniqueId
                            ) { cosmetic in
                                CosmeticCell(
                                    cosmeticTitle: cosmetic.cosmeticTitle,
                                    assetName: cosmetic.assetName,
                                    isSelected: cosmetic.uniqueId
                                        == characterData.eyeCosmetic.uniqueId,
                                    onTap: {
                                        characterData.eyeCosmetic = cosmetic
                                        userDataStore.updateCharacter(
                                            characterData)
                                        print(
                                            "Updated eye cosmetic to: \(cosmetic.cosmeticTitle)"
                                        )
                                    }
                                )
                            }
                        }
                    }
                    .padding(16)
                }

                Spacer()
            }
            .background(ColorTheme.background)
            .toolbarVisibility(.hidden, for: .navigationBar)
        }
        .onAppear {
            if let storedCharacter = userDataStore.userData?.character {
                characterData = storedCharacter
                print("Loaded character data: \(characterData)")
            } else {
                print("No character data found.")
            }
        }
    }
}





struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample UserDataStore with mock user data.
        let store = UserDataStore(userId: "previewUser")

        // Sample cosmetics for preview.
        let sampleHeadCosmetics: [HeadCosmetic] = [
            HeadCosmetic.defaultCosmetic,
            HeadCosmetic(
                cosmeticId: 2,
                assetName: "hc_beanie",
                cosmeticTitle: "Beanie",
                relativeScale: 0.45,
                offsetXRatio: 0,
                offsetYRatio: -0.25,
                rotation: 0,
                price: 10
            ),
        ]
        let sampleEyeCosmetics: [EyeCosmetic] = [
            EyeCosmetic.defaultCosmetic,
            EyeCosmetic(
                cosmeticId: 2,
                assetName: "ec_sunglasses",
                cosmeticTitle: "Sunglasses",
                relativeScale: 0.45,
                offsetXRatio: 0,
                offsetYRatio: 0,
                rotation: 0,
                price: 10
            ),
        ]
        let sampleUnlocked = UnlockedCosmetics(
            headCosmetics: sampleHeadCosmetics,
            eyeCosmetics: sampleEyeCosmetics
        )
        let sampleInventory = InventoryData(
            currency: 1000,
            unlockedCosmetics: sampleUnlocked
        )
        let sampleSettings = SettingsData(
            musicVolume: 0.5,
            sfxVolume: 0.5,
            textSize: 1.0,
            selectedLanguage: "English"
        )
        let sampleProgress = ProgressData()
        let sampleCharacter = CharacterData.defaultCharacter

        store.userData = UserData(
            settings: sampleSettings,
            progress: sampleProgress,
            inventory: sampleInventory,
            character: sampleCharacter
        )

        let auth = AuthenticationManager()
        auth.currentUserId = "previewUser"

        return InventoryView()
            .environmentObject(store)
            .environmentObject(auth)
            .previewDevice("iPhone 14")
    }
}
