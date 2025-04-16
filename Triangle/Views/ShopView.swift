//
//  ShopView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 12.03.2025.
//

import SwiftUI

struct ShopView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @State var randomCosmetics: [any Cosmetic] = []

    // Helper function to check if a cosmetic is unlocked.
    // TODO: Move this somewhere else
    func isCosmeticUnlocked(_ cosmetic: any Cosmetic) -> Bool {
        guard let inventory = userDataStore.userData?.inventory else {
            return false
        }
        if let headCosmetic = cosmetic as? HeadCosmetic {
            return inventory.unlockedCosmetics.headCosmetics.contains {
                $0.uniqueId == headCosmetic.uniqueId
            }
        } else if let eyeCosmetic = cosmetic as? EyeCosmetic {
            return inventory.unlockedCosmetics.eyeCosmetics.contains {
                $0.uniqueId == eyeCosmetic.uniqueId
            }
        }
        return false
    }

    var body: some View {
        NavigationStack {
            TopNavigationBar(title: "Shop", onBack: nil)
            VStack {
                Spacer()

                if horizontalSizeClass == .compact {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            ForEach(randomCosmetics.prefix(2), id: \.uniqueId) {
                                cosmetic in
                                ShopCard(
                                    cosmetic: cosmetic,
                                    isUnlocked: isCosmeticUnlocked(cosmetic)
                                ) {
                                    userDataStore.buyCosmetic(cosmetic)
                                }
                            }
                        }
                        HStack(spacing: 16) {
                            ForEach(
                                randomCosmetics.dropFirst(2).prefix(2),
                                id: \.uniqueId
                            ) { cosmetic in
                                ShopCard(
                                    cosmetic: cosmetic,
                                    isUnlocked: isCosmeticUnlocked(cosmetic)
                                ) {
                                    userDataStore.buyCosmetic(cosmetic)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                } else {
                    HStack(spacing: 16) {
                        ForEach(randomCosmetics, id: \.uniqueId) { cosmetic in
                            ShopCard(
                                cosmetic: cosmetic,
                                isUnlocked: isCosmeticUnlocked(cosmetic)
                            ) {
                                userDataStore.buyCosmetic(cosmetic)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()

                Button("Refresh Shop") {
                    print("Shop refreshed")
                    randomCosmetics = userDataStore.getRandomCosmetics()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(ColorTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Add 1000 currency") {
                    print("1000 currency added")
                    userDataStore.userData?.inventory.addCurrency(1000)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(ColorTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Lock all cosmetics") {
                    print("All cosmetics locked")
                    userDataStore.userData?.inventory.unlockedCosmetics.self = UnlockedCosmetics.defaultUnlockedCosmetics
                    userDataStore.userData?.character = CharacterData.defaultCharacter
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(ColorTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(ColorTheme.background)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .onAppear {
            randomCosmetics = userDataStore.getRandomCosmetics()
        }
    }
}

#Preview {
    ShopView()
        .environmentObject(UserDataStore(userId: "almezj"))
        .environmentObject(AuthenticationManager())
}
