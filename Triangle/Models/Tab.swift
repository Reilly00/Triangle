//
//  Tab.swift
//  Triangle
//
//  Created by Josef Zemlicka on 22.02.2025.
//

import Foundation
import SwiftUI

enum Tab: Int, CaseIterable {
    case shop = 0
    case dashboard = 1
    case profile = 2

    var title: String {
        switch self {
        case .shop: return "Shop"
        case .dashboard: return "Dashboard"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .shop: return "cart.fill"
        case .dashboard: return "gamecontroller.fill"
        case .profile: return "person.fill"
        }
    }
}
