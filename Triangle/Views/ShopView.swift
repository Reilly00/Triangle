import SwiftUI

struct ShopView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var randomCosmetics: [any Cosmetic] = []
    @State private var userInventory: InventoryData?

    func isCosmeticUnlocked(_ cosmetic: any Cosmetic) -> Bool {
        guard let inventory = userInventory else { return false }
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
                            ForEach(randomCosmetics.prefix(2), id: \.uniqueId) { cosmetic in
                                ShopCard(
                                    cosmetic: cosmetic,
                                    isUnlocked: isCosmeticUnlocked(cosmetic)
                                ) {
                                    userDataStore.buyCosmetic(cosmetic)
                                    userInventory = userDataStore.userData?.inventory // ✅ Update UI
                                    userDataStore.save() // ✅ Save to CloudKit
                                }
                            }
                        }
                        HStack(spacing: 16) {
                            ForEach(randomCosmetics.dropFirst(2).prefix(2), id: \.uniqueId) { cosmetic in
                                ShopCard(
                                    cosmetic: cosmetic,
                                    isUnlocked: isCosmeticUnlocked(cosmetic)
                                ) {
                                    userDataStore.buyCosmetic(cosmetic)
                                    userInventory = userDataStore.userData?.inventory // ✅ Update UI
                                    userDataStore.save() // ✅ Save to CloudKit
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
                                userInventory = userDataStore.userData?.inventory // ✅ Update UI
                                userDataStore.save() // ✅ Save to CloudKit
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()

                Button("Refresh Shop") {
                    print("Shop refreshed")
                    randomCosmetics = Array(Set(userDataStore.getRandomCosmetics().map { $0.uniqueId }))
                        .compactMap { id in userDataStore.getRandomCosmetics().first(where: { $0.uniqueId == id }) }
                }

                .padding()
                .frame(maxWidth: .infinity)
                .background(ColorTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Add 1000 currency") {
                    print("1000 currency added")
                    if var inventory = userDataStore.userData?.inventory {
                        inventory.addCurrency(1000)
                        userDataStore.updateInventory(inventory) // Ensure persistence
                        userInventory = inventory // Update UI
                        userDataStore.save() // Saves to both local storage & CloudKit
                    }
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
            randomCosmetics = userDataStore.getRandomCosmetics().reduce(into: [any Cosmetic]()) { seen, cosmetic in
                if !seen.contains(where: { $0.uniqueId == cosmetic.uniqueId }) {
                    seen.append(cosmetic)
                }
            }
            userInventory = userDataStore.userData?.inventory // ✅ Initialize inventory on load
        }
    }
}

#Preview {
    ShopView()
        .environmentObject(UserDataStore(userId: "almezj"))
        .environmentObject(AuthenticationManager())
}
