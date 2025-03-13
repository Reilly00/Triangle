//
//  EmotionRecognitionController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class EmotionRecognitionController: ObservableObject {
    let targetEmotion: Emotion
    let availableEmotions: [Emotion]

    @Published var selectedEmotion: Emotion? = nil
    @Published var isCorrect: Bool? = nil

    init(predefinedEmotion: Emotion? = nil) {
        let initialEmotion = predefinedEmotion ?? Emotion.random()
        self.targetEmotion = initialEmotion

        var otherEmotions = Emotion.allCases.filter { $0 != initialEmotion }
            .shuffled()
        let incorrectOptions = Array(otherEmotions.prefix(2))

        self.availableEmotions = ([initialEmotion] + incorrectOptions)
            .shuffled()
    }

    /// Checks the answer selected by the user.
    /// - Parameters:
    ///   - selected: The emotion chosen by the user.
    ///   - onComplete: Closure to call when the answer is correct.
    ///   - dismiss: Closure to dismiss the view after a delay.
    func checkAnswer(
        selected: Emotion, onComplete: @escaping () -> Void,
        dismiss: @escaping () -> Void
    ) {
        self.selectedEmotion = selected
        self.isCorrect = (selected == targetEmotion)

        if isCorrect == true {
            onComplete()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.selectedEmotion = nil
                self.isCorrect = nil
            }
        }
    }
}
