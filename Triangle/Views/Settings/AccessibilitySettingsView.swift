//
//  AccessibilitySettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 20.02.2025.
//

import SwiftUI

struct AccessibilitySettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        ZStack {
            ColorTheme.background
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Accessibility Settings")
                    .font(.system(size: 28 * settings.textSize, weight: .bold, design: .rounded))
                    .padding(.top, 40)
                    .foregroundColor(ColorTheme.text)

                VStack(alignment: .leading, spacing: 20) {
                    // Text Size Adjustment
                    Text("Text Size")
                        .font(.system(size: 20 * settings.textSize, weight: .semibold, design: .rounded))
                        .foregroundColor(ColorTheme.text)

                    Slider(value: $settings.textSize, in: 0.8...1.5, step: 0.1)
                        .tint(ColorTheme.accent)
                        .padding(.horizontal)

                    // High Contrast Mode Toggle
                    Toggle(isOn: $settings.highContrastMode) {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("High Contrast Mode")
                                .font(.system(size: 18 * settings.textSize, weight: .semibold, design: .rounded))
                        }
                    }
                    .padding()
                    .background(ColorTheme.shadowGray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                .frame(maxWidth: 400)
                .background(ColorTheme.shadowGray)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Accessibility")
    }
}

struct AccessibilitySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilitySettingsView()
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(SettingsViewModel())
    }
}
