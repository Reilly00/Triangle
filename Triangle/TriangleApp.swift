//
//  TriangleApp.swift
//  Triangle
//
//  Created by Josef Zemlicka on 02.01.2025.
//

import SwiftUI

@main
struct TriangleApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environmentObject(settingsViewModel)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
