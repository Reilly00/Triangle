//
//  DashboardController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class DashboardController: ObservableObject {
    @Published var selectedExerciseParameters: ExerciseParameters?

    private let userDataStore: UserDataStore

    init(userDataStore: UserDataStore) {
        self.userDataStore = userDataStore
    }

    /// Called when a dashboard card is tapped to set up navigation.
    func selectExercise(id: Int, totalTriangles: Int, currentLevelIndex: Int) {
        let params = ExerciseParameters(
            id: id,
            totalTriangles: totalTriangles,
            currentLevelIndex: currentLevelIndex
        )
        self.selectedExerciseParameters = params
    }

    /// Returns exercise information for a given exercise id and total number of levels.
    /// - Parameters:
    ///   - id: The exercise identifier.
    ///   - totalLevels: The total number of levels for the exercise.
    /// - Returns: A tuple containing the progress (as a fraction) and the current level.
    func getExerciseInfo(forExerciseId id: Int, totalLevels: Int) -> (
        progress: Double, currentLevel: Int
    ) {
        guard let userData = userDataStore.userData else {
            return (0, 1)
        }
        let progressData = userData.progress
        if let exerciseProgress = progressData.exerciseProgresses.first(where: {
            $0.exerciseId == id
        }) {
            let completedCount = exerciseProgress.levels.filter { $0.completed }
                .count
            let progress = Double(completedCount) / Double(totalLevels)
            let currentLevel = exerciseProgress.currentLevelId
            return (progress, currentLevel)
        }
        return (0, 1)
    }
}
