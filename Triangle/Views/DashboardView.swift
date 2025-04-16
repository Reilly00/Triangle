//
//  ContentView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

// MARK: - DashboardView
struct DashboardView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @StateObject var dashboardController: DashboardController
    @State private var navigationPath = NavigationPath()

    init(userDataStore: UserDataStore) {
        _dashboardController = StateObject(
            wrappedValue: DashboardController(userDataStore: userDataStore)
        )
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Dashboard", onBack: nil)
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                            ],
                            spacing: 10
                        ) {
                            NavigationLink(destination: ExerciseSelectorView()) {
                                DashboardCard(title: "Exercises", imageName: "exercises_mascot")
                                    .frame(maxHeight: 400)
                            }
                            NavigationLink(destination: MinigameSelectorView()) {
                                DashboardCard(title: "Minigames", imageName: "minigames_mascot")
                                    .frame(maxHeight: 400)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()

            }
            // Hide the system navigation bar.
            .toolbar(.hidden, for: .navigationBar)
            .background(Color(hex: 0xB5CFE3))
        }
    }

    // MARK: - Helper Functions

    func titleForExercise(exerciseId: Int) -> String {
        switch exerciseId {
        case 1: return "Getting Started"
        case 2: return "A Day in the Park"
        case 3: return "School Sports Day"
        case 4: return "Coming soon..."
        default: return "Exercise \(exerciseId)"
        }
    }

    func imageNamesForExercise(exerciseId: Int) -> [String] {
        return ["SocialTriangle"]
    }

    func isExerciseLocked(exerciseId: Int, currentLevel: Int) -> Bool {
        if exerciseId == 1 { return false }
        return currentLevel == 1
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let userDataStore = UserDataStore(userId: "previewUser")
        userDataStore.userData = userDataStore.loadUserData(for: "previewUser")
        return DashboardView(userDataStore: userDataStore)
            .environmentObject(NavbarVisibility())
            .environmentObject(userDataStore)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
