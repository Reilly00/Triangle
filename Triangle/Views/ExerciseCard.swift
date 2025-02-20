//
//  ExerciseCard.swift
//  Triangle
//
//  Created by Josef Zemlicka on 09.01.2025.
//

import SwiftUI


struct ExerciseCard: View {
    @EnvironmentObject var settings: SettingsViewModel
    let title: String
    let isLocked: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(isLocked ? ColorTheme.lightGray : ColorTheme.primary)
                    .frame(height: 150)
                    .overlay(
                        VStack {
                            if isLocked {
                                Image(systemName: "lock.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            } else {
                                Text(title)
                                    .font(.montserratHeadline(textSize: settings.textSize))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    )
            }
        }
        .disabled(isLocked)
        .padding(.horizontal)
    }
}
