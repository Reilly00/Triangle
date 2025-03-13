//
//  BodyLanguageRecognitionExercise.swift
//  Triangle
//
//  Created by Dillon Reilly on 03/02/2025.
//

import SwiftUI

struct BodyLanguageRecognitionExercise: Exercise {
    let id: Int
    let title: String
    let description: String
    var isCompleted: Bool = false
    let targetBodyLanguage: BodyLanguage  // ✅ The body language to match

    init(id: Int = 2, targetBodyLanguage: BodyLanguage? = nil) {
        self.id = id
        self.targetBodyLanguage = targetBodyLanguage ?? BodyLanguage.random()
        self.title = "Body Language Recognition"
        self.description = "Match the correct body language to the emotion!"
    }

    func startExercise(onComplete: @escaping () -> Void) -> AnyView {
        return AnyView(BodyLanguageRecognitionView(targetBodyLanguage: targetBodyLanguage, onComplete: onComplete))
    }
}
