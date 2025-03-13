//
//  ProfileController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class ProfileController: ObservableObject {
    @Published var progress: Double = 0.75
    @Published var activities: [String] = [
        "Completed 'Social Cues' exercise",
        "Unlocked 'Party Hat' cosmetic",
        "Achieved Level 5 in Focus Training",
    ]

    // TODO: Save and load to local storage
    // For now, these are hardcoded placeholder values.

    func updateProgress(newProgress: Double) {
        progress = newProgress
    }

    func addActivity(_ activity: String) {
        activities.append(activity)
    }
}
