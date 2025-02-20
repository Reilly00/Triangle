//
//  SettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 23.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel

    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(ColorTheme.background)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.system(size: 42 * settings.textSize, weight: .bold, design: .rounded))
                        .padding(.top, 40)
                        .foregroundColor(ColorTheme.text)
                    Spacer()
                    HStack(spacing: 30) {
                        SettingsButton(title: "General", systemImage: "gearshape.fill", destination: GeneralSettingsView())
                        SettingsButton(title: "Sound", systemImage: "speaker.wave.2.fill", destination: SoundSettingsView())
                        
                    }
                    .padding()
                    HStack(spacing: 30){
                        SettingsButton(title: "Accessibility", systemImage: "accessibility.fill", destination: AccessibilitySettingsView())
                        SettingsButton(title: "About", systemImage: "info.bubble.fill", destination: AboutView())
                    }
                    .padding()
                }
            }
        }
    }
}

struct SettingsButton<Destination: View>: View {
    @EnvironmentObject var settings: SettingsViewModel
    let title: String
    let systemImage: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination.environmentObject(SettingsViewModel())) {
            VStack {
                Spacer()
                Image(systemName: systemImage)
                    .font(.system(size: 64 * settings.textSize, weight: .medium))
                Spacer()
                Text(title)
                    .font(.system(size: 28 * settings.textSize, weight: .semibold, design: .rounded))
                Spacer()
            }
            .frame(width: 300, height: 300)
            .background(ColorTheme.accent)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .foregroundColor(ColorTheme.text)
            .shadow(radius: 2)
        }
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(SettingsViewModel())
    }
}

