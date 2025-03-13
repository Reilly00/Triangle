//
//  Emotion.swift
//  Triangle
//
//  Created by Dillon Reilly on 02/02/2025.
//

import Foundation

enum Emotion: String, CaseIterable {
    case happy = "Happy"
    case sad = "Sad"
    case crying = "Crying"
    case sleepy = "Sleepy"
    case angry = "Angry"
    case surprised = "Surprised"

    /// Returns the animation name inside the Rive file "ch_t"
    var animationName: String {
        switch self {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .crying: return "crying"
        case .sleepy: return "sleepy"
        case .angry: return "angry"
        case .surprised: return "surprised"
        }
    }

    /// Returns a random emotion for the exercise
    static func random() -> Emotion {
        return Emotion.allCases.randomElement() ?? .happy
    }
}
