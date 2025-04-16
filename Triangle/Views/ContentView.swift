//
//  ContentView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .dashboard
    @StateObject var navbarVisibility = NavbarVisibility()
    @EnvironmentObject var userDataStore: UserDataStore

    var body: some View {
        ZStack {
            // Main content (with background)
            Group {
                switch selectedTab {
                case .shop:
                    ShopView()
                case .dashboard:
                    DashboardView(userDataStore: userDataStore)
                case .profile:
                    ProfileView()
                }
            }
            .environmentObject(navbarVisibility)
            .ignoresSafeArea(edges: .top)
            .background(ColorTheme.background)
            

            // Overlay the navbar at the bottom
            if navbarVisibility.isVisible {
                VStack {
                    Spacer()
                    Navbar(selectedTab: $selectedTab)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
        .environmentObject(UserDataStore(userId: "guest"))
}
