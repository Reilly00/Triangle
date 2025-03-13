//
//  Untitled.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation

struct Level: Codable, Equatable {
    var levelId: Int
    var completed: Bool
    var currency: Int
    var experience: Int
}

struct ExerciseProgress: Codable, Equatable {
    var exerciseId: Int
    var currentLevelId: Int
    var levels: [Level]

    mutating func completeLevel(levelId: Int) {
        if let index = levels.firstIndex(where: { $0.levelId == levelId }) {
            levels[index].completed = true
        } else {

            let newLevel = Level(
                levelId: levelId, completed: true, currency: 0, experience: 0)
            levels.append(newLevel)
        }

        if levelId == currentLevelId {
            currentLevelId = levelId + 1
        }
    }
    
}

struct ProgressData: Codable,Equatable {
    var exerciseProgresses: [ExerciseProgress]

    init(exerciseProgresses: [ExerciseProgress] = []) {
        self.exerciseProgresses = exerciseProgresses
    }

    mutating func markLevelCompleted(
        forExerciseId exerciseId: Int, levelId: Int
    ) {
        if let index = exerciseProgresses.firstIndex(where: {
            $0.exerciseId == exerciseId
        }) {
            exerciseProgresses[index].completeLevel(levelId: levelId)
        } else {
            let newExercise = ExerciseProgress(
                exerciseId: exerciseId,
                currentLevelId: levelId + 1,
                levels: [
                    Level(
                        levelId: levelId, completed: true, currency: 0,
                        experience: 0)
                ]
            )
            exerciseProgresses.append(newExercise)
        }
    }
    
    func prettyPrint() {
        print(self.description)
    }
}

extension ProgressData: CustomStringConvertible {
    var description: String {
        "ProgressData with \(exerciseProgresses.count) exercises"
    }

    static let defaultProgress: ProgressData = ProgressData()
}
