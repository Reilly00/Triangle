//
//  MinigameSelectortView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 24.03.2025.
//

import SwiftUI

struct MinigameSelectorView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var dashboardController: DashboardController
    @Environment(\.dismiss) var dismiss

    private let exercises: [(id: Int, totalLevels: Int)] = [
        (1, 8), (2, 8), (3, 8), (4, 8),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Minigames", onBack: { dismiss() })
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                            ],
                            spacing: 10
                        ) {
                            NavigationLink(destination: FlappyTomGameView()) {
                                DashboardCard(
                                    title: "Flappy Tom", imageName: "flappytom")
                            }
                            .frame(maxWidth: .infinity)
                            NavigationLink(destination: HoopsGameView()) {
                                DashboardCard(
                                    title: "Hoops", imageName: "hoops")
                            }
                            .frame(maxWidth: .infinity)
                            NavigationLink(destination: MemoryMatchView()) {
                                DashboardCard(
                                    title: "Memory Match",
                                    imageName: "memorymatch")
                            }
                            .frame(maxWidth: .infinity)
                            NavigationLink(destination: BrickBreakerView()) {
                                DashboardCard(
                                    title: "Brick Breaker",
                                    imageName: "brickbreaker")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: ExerciseParameters.self) { params in
                LevelSelectorView(
                    exerciseId: params.id,
                    totalTriangles: params.totalTriangles
                )
                .environmentObject(navbarVisibility)
            }
            .background(Color(hex: 0xB5CFE3))
        }
    }
}

struct MinigameView: View {
    var body: some View {
        Text("Minigame View")
    }
}

struct MinigameSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let userDataStore = UserDataStore(userId: "previewUser")
        userDataStore.userData = userDataStore.loadUserData(for: "previewUser")
        return MinigameSelectorView()
            .environmentObject(NavbarVisibility())
            .environmentObject(userDataStore)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
