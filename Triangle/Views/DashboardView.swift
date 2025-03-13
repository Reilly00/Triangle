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

enum DashboardDestination: Hashable, Identifiable {
    case levelTransition(ExerciseParameters)
    case levelSelector(ExerciseParameters)

    var id: Self { self }
}

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
            ScrollView {
                VStack {
                    // Define your exercise definitions.
                    let exercises: [(id: Int, totalLevels: Int)] = [
                        (1, 8), (2, 8), (3, 8), (4, 8),
                    ]

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()), GridItem(.flexible()),
                        ],
                        spacing: 40
                    ) {
                        ForEach(exercises, id: \.id) { exercise in
                            let info = dashboardController.getExerciseInfo(
                                forExerciseId: exercise.id,
                                totalLevels: exercise.totalLevels
                            )
                            DashboardCard(
                                title: titleForExercise(
                                    exerciseId: exercise.id),
                                imageNames: imageNamesForExercise(
                                    exerciseId: exercise.id),
                                progress: info.progress,
                                currentExercise: info.currentLevel,
                                locked: isExerciseLocked(
                                    exerciseId: exercise.id,
                                    currentLevel: info.currentLevel
                                ),
                                action: {
                                    // When a dashboard card is tapped, create parameters and push a levelTransition destination.
                                    let params = ExerciseParameters(
                                        id: exercise.id,
                                        totalTriangles: exercise.totalLevels,
                                        currentLevelIndex: info.currentLevel
                                    )
                                    navigationPath.append(
                                        DashboardDestination.levelTransition(
                                            params))
                                }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(20)
            }
            .onAppear {
                navbarVisibility.isVisible = true
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0xB5CFE3))
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(for: DashboardDestination.self) {
                destination in
                switch destination {
                case .levelTransition(let params):
                    LevelTransitionView(
                        onCompletion: {
                            navigationPath.removeLast()
                            navigationPath.append(
                                DashboardDestination.levelSelector(params))
                        }
                    )
                    .environmentObject(navbarVisibility)
                case .levelSelector(let params):
                    LevelSelectorView(
                        exerciseId: params.id,
                        totalTriangles: params.totalTriangles,
                        currentLevelIndex: params.currentLevelIndex
                    )
                    .environmentObject(navbarVisibility)
                }
            }
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
