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
            VStack(spacing: 0) {
                TopNavigationBar(
                    title: authManager.currentUserId ?? "Profile", onBack: nil)
                ScrollView {
                    VStack {
                        Character(characterData: characterData)
                            .frame(height: 400)
                            .padding()
                        NavigationLink(
                            destination: InventoryView()
                        ) {
                            Text("Customise")
                                .font(.pageTitle)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(ColorTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    VStack {
                        ZStack {
                            Rectangle()
                                .frame(height: 700)
                                .foregroundColor(ColorTheme.primary)
                                .cornerRadius(20)
                            Text("Badges\nand\nAchievements")
                                .multilineTextAlignment(.center)
                                .font(
                                    .system(
                                        size: 32, weight: .bold,
                                        design: .default)
                                )
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .background(ColorTheme.background)
            }
        }
        .navigationBarHidden(true)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        return ProfileView()
            .environmentObject(UserDataStore(userId: "guest"))
            .environmentObject(AuthenticationManager())
    }
}
