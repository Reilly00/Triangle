//
//  SoundSettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 20.02.2025.
//

import SwiftUI

struct SoundSettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        ZStack {
            ColorTheme.background
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Sound Settings")
                    .font(.system(size: 28 * settings.textSize, weight: .bold, design: .rounded))
                    .padding(.top, 40)
                    .foregroundColor(ColorTheme.text)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Music Volume")
                        .font(.system(size: 20 * settings.textSize, weight: .semibold, design: .rounded))
                        .foregroundColor(ColorTheme.text)

                    Slider(value: $settings.musicVolume, in: 0...1, step: 0.1)
                        .tint(ColorTheme.accent)
                        .padding(.horizontal)

                    Text("SFX Volume")
                        .font(.system(size: 20 * settings.textSize, weight: .semibold, design: .rounded))
                        .foregroundColor(ColorTheme.text)

                    Slider(value: $settings.sfxVolume, in: 0...1, step: 0.1)
                        .tint(ColorTheme.accent)
                        .padding(.horizontal)

                    Button(action: {
                        toggleMute()
                    }) {
                        HStack {
                            Image(systemName: settings.musicVolume == 0 && settings.sfxVolume == 0 ? "speaker.slash.fill" : "speaker.3.fill")
                                .font(.system(size: 22))
                            Text(settings.musicVolume == 0 && settings.sfxVolume == 0 ? "Unmute" : "Mute All")
                                .font(.system(size: 18 * settings.textSize, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(ColorTheme.accent)
                        .foregroundColor(ColorTheme.text)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
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
        .navigationTitle("Sound")
    }

    private func toggleMute() {
        if settings.musicVolume == 0 && settings.sfxVolume == 0 {
            settings.musicVolume = 0.5
            settings.sfxVolume = 0.5
        } else {
            settings.musicVolume = 0
            settings.sfxVolume = 0
        }
    }
}

struct SoundSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingsView()
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(SettingsViewModel())
    }
}
