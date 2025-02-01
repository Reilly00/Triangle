//
//  LevelTransitionView.swift
//  Triangle
//
//  Created by Dillon Reilly on 31/01/2025.
//

import SwiftUI
import RiveRuntime

struct LevelTransitionView: View {
    @State private var navigateToLogin = false
    @State private var riveViewModel = RiveViewModel(fileName: "jump-2") // ✅ Load animation by filename

    var body: some View {
        ZStack {
            Color(hex: 0xB5CFE3)
                .edgesIgnoringSafeArea(.all)

            VStack {
                riveViewModel.view()
                    .frame(width: 300, height: 300)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: 0x4C708A)))
                    .scaleEffect(2)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                navigateToLogin = true
            }
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            OnboardingView()
        }
    }
}
