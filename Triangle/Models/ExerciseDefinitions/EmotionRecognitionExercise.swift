//
//  EmotionRecognitionExercise.swift
//  Triangle
//
//  Created by Dillon Reilly on 02/02/2025.
//

import SwiftUI

struct EmotionRecognitionExercise: Exercise {
    let id: Int
    let title: String
    let description: String
    var isCompleted: Bool = false
    let predefinedEmotion: Emotion?

    init(id: Int = 1, predefinedEmotion: Emotion? = nil) {
        self.id = id
        self.predefinedEmotion = predefinedEmotion
        self.title = "Emotion Recognition"
        self.description = "Identify the emotion displayed by Tom the Triangle!"
    }

    func startExercise(onComplete: @escaping () -> Void) -> AnyView {
        print("Starting Emotion Recognition Exercise...")
        return AnyView(EmotionRecognitionView(predefinedEmotion: predefinedEmotion, onComplete: onComplete))
    }
}
