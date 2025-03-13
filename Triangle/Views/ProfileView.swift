//
//  ProfileView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileController = ProfileController()
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var characterData: CharacterData = CharacterData
        .defaultCharacter

    var body: some View {

        NavigationStack {
            TopNavigationBar(
                title: authManager.currentUserId ?? "Profile", onBack: nil)
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    // TODO: Add more stuff to the profile page such as achievements, character customization etc.
                    // Currently there is only the character with two buttons to change the cosmetics
                    VStack {
                        Character(characterData: characterData)
                            .frame(height: 400)
                            .padding()
                        Button("Change Head Cosmetic") {
                            if let catalog = userDataStore.cosmeticCatalog,
                                let currentIndex = catalog.headCosmetics
                                    .firstIndex(where: {
                                        $0.cosmeticId
                                            == characterData.headCosmetic
                                            .cosmeticId
                                    })
                            {
                                // Cycle through cosmetics
                                let nextIndex =
                                    (currentIndex + 1)
                                    % catalog.headCosmetics.count
                                characterData.headCosmetic =
                                    catalog.headCosmetics[nextIndex]
                                userDataStore.updateCharacter(characterData)
                                print(
                                    "Next head cosmetic: \(catalog.headCosmetics[nextIndex])"
                                )
                            } else {
                                print("No catalog found")
                            }
                        }
                        .padding()
                        .background(ColorTheme.primary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        Button("Change Eye Cosmetic") {
                            if let catalog = userDataStore.cosmeticCatalog,
                                let currentIndex = catalog.eyeCosmetics
                                    .firstIndex(where: {
                                        $0.cosmeticId
                                            == characterData.eyeCosmetic
                                            .cosmeticId
                                    })
                            {
                                // Cycle to the next cosmetic; wrap around if at end
                                let nextIndex =
                                    (currentIndex + 1)
                                    % catalog.eyeCosmetics.count
                                characterData.eyeCosmetic =
                                    catalog.eyeCosmetics[nextIndex]
                                userDataStore.updateCharacter(characterData)
                                print(
                                    "Next eye cosmetic: \(catalog.eyeCosmetics[nextIndex])"
                                )
                            }
                        }
                        .padding()
                        .background(ColorTheme.primary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        NavigationLink(
                            destination: SettingsView(
                                settingsController: SettingsController(
                                    userDataStore: userDataStore))
                        ) {
                            Text("Settings")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(ColorTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                Spacer()
                Spacer()
            }
            .background(ColorTheme.background)
            .toolbarBackground(.hidden, for: .navigationBar)
            .onAppear {
                print("Current user data: \(userDataStore.userData)")
                if let storedCharacter = userDataStore.userData?.character {
                    characterData = storedCharacter
                    print("Loaded character data: \(characterData)")
                } else {
                    print("No character data found.")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserDataStore(userId: "previewUser"))
            .environmentObject(AuthenticationManager())
    }
}
