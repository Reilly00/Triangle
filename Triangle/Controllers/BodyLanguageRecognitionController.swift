//
//  BodyLanguageRecognitionController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

final class BodyLanguageRecognitionController: ObservableObject {
    let targetBodyLanguage: BodyLanguage
    let availableBodyLanguages: [BodyLanguage]
    
    @Published var selectedBodyLanguage: BodyLanguage? = nil
    @Published var isCorrect: Bool? = nil
    
    init(targetBodyLanguage: BodyLanguage? = nil) {
        let initial = targetBodyLanguage ?? BodyLanguage.random()
        self.targetBodyLanguage = initial
        
        var otherOptions = BodyLanguage.allCases.filter { $0 != initial }.shuffled()
        let incorrectOptions = Array(otherOptions.prefix(2))
        
        self.availableBodyLanguages = ([initial] + incorrectOptions).shuffled()
    }
    
    /// Checks the user's selected body language.
    /// - Parameters:
    ///   - selected: The body language option chosen by the user.
    ///   - onComplete: A closure called when the answer is correct.
    ///   - dismiss: A closure used to dismiss the view after a delay.
    func checkAnswer(selected: BodyLanguage, onComplete: @escaping () -> Void, dismiss: @escaping () -> Void) {
        self.selectedBodyLanguage = selected
        self.isCorrect = (selected == targetBodyLanguage)
        
        if isCorrect == true {
            onComplete()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.selectedBodyLanguage = nil
                self.isCorrect = nil
            }
        }
    }
}
