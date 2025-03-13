//
//  BodyLanguage.swift
//  Triangle
//
//  Created by Dillon Reilly on 03/02/2025.
//

import Foundation

enum BodyLanguage: String, CaseIterable {
    case surprised = "Surprised"
    case frustrated = "Frustrated"
    case proud = "Proud"
    case angry = "Angry"
    case shocked = "Shocked"
    case celebrating = "Celebrating"

    /// Returns the correct image name for each body language
    var imageName: String {
        switch self {
        case .surprised: return "bodylang1.1"
        case .frustrated: return "bodylang1.2"
        case .proud: return "bodylang1.3"
        case .angry: return "bodylang2.1"
        case .shocked: return "bodylang2.2"
        case .celebrating: return "bodylang2.3"
        }
    }

    /// Returns a random body language for the exercise
    static func random() -> BodyLanguage {
        return BodyLanguage.allCases.randomElement() ?? .surprised
    }
}

