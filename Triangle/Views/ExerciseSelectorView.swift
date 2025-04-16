//
//  ContentView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

struct ExerciseParameters: Identifiable, Hashable {
    let id: Int
    let totalTriangles: Int
    let currentLevelIndex: Int
}

struct ExerciseSelectorView: View {
    @EnvironmentObject var navbarVisibility: NavbarVisibility
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var dashboardController: DashboardController
    @Environment(\.dismiss) var dismiss

    private let exercises: [(id: Int, totalLevels: Int)] = [
        (1, 8), (2, 8), (3, 8), (4, 8)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavigationBar(title: "Exercises", onBack: { dismiss() })
                ScrollView {
                    VStack {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 10
                        ) {
                            ForEach(exercises, id: \.id) { exercise in
                                if exercise.id == 1 {
                                    NavigationLink(destination: LevelSelectorView(exerciseId: exercise.id, totalTriangles: 10)) {
                                        ExerciseCard(id: exercise.id, isLocked: false)
                                    }
                                } else {
                                    ExerciseCard(id: exercise.id, isLocked: true)
                                }
                            }
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

struct ExerciseSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let userDataStore = UserDataStore(userId: "previewUser")
        userDataStore.userData = userDataStore.loadUserData(for: "previewUser")
        return ExerciseSelectorView()
            .environmentObject(NavbarVisibility())
            .environmentObject(userDataStore)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPad Pro 11-inch")
    }
}
