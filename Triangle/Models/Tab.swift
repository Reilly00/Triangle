//
//  Tab.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.02.2025.
//

import Foundation
import SwiftUI

enum Tab: Int, CaseIterable {
    case leaderboard = 0
    case dashboard = 1
    case profile = 2

    var title: String {
        switch self {
        case .leaderboard: return "Leaderboard"
        case .dashboard: return "Dashboard"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .leaderboard: return "globe"
        case .dashboard: return "gamecontroller.fill"
        case .profile: return "person.fill"
        }
    }
}
