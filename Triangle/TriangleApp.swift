//
//  TriangleApp.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

@main
struct TriangleApp: App {
    @StateObject var authManager = AuthenticationManager()
    @StateObject var userDataStore = UserDataStore(userId: "guest")

    init() {
        print(
            "UserDefaults at startup: \(UserDefaults.standard.dictionaryRepresentation())"
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .environmentObject(userDataStore)
                .onAppear {
                    if let userId = authManager.currentUserId, userId != "guest"
                    {
                        userDataStore.updateUserId(userId)
                        print("Logged in as \(userId)")
                        print(
                            "DataStore"
                                + "\(UserDefaults.standard.dictionaryRepresentation())"
                        )
                        userDataStore.cosmeticCatalog = loadCosmeticCatalog()
                        print("Catalog loaded")
                        print(userDataStore.cosmeticCatalog ?? "No catalog")
                    }
                }
                .onAppear {
                    Font.textScale = CGFloat(userDataStore.userData?.settings.textSize ?? 1)
                }
                .onChange(of: userDataStore.userData?.settings.textSize) { _, newSize in
                    Font.textScale = CGFloat(userDataStore.userData?.settings.textSize ?? 1)
                }
                .onChange(of: authManager.currentUserId) { _, newSize in
                    if let userId = authManager.currentUserId, userId != "guest"
                    {
                        userDataStore.updateUserId(userId)
                        print("Logged in as \(userId)")
                        print(
                            "DataStore"
                            + "\(UserDefaults.standard.dictionaryRepresentation())"
                        )
                    }
                }
        }
    }
}

struct RootView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        if authManager.currentUserId != nil {
            ContentView()
        } else {
            OnboardingView()
        }
    }
}

struct TriangleApp_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(UserDataStore(userId: "guest"))
            .environmentObject(AuthenticationManager())
    }
}
