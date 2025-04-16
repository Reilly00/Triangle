//
//  SettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 23.01.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject var settingsController: SettingsController
    @State private var showPrivacyPolicy: Bool = false

    init(userDataStore: UserDataStore) {
        _settingsController = StateObject(wrappedValue: SettingsController(userDataStore: userDataStore))
    }

    var body: some View {
        NavigationStack {
            
            if let settings = userDataStore.userData?.settings {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Account Section
                        Group {
                            Text("Account")
                                .font(.pageTitle)
                            Button("Update Email") {
                                print("Update Email button tapped")
                            }
                            .buttonStyle(TrianglePrimaryButton())

                            Button("Change Password") {
                                print("Change Password button tapped")
                            }
                            .buttonStyle(TrianglePrimaryButton())
                            Button("Log Out") {
                                print("Log Out button tapped")
                                authManager.logout(userDataStore: userDataStore)
                            }
                            .buttonStyle(TrianglePrimaryButton())
                        }

                        Divider()

                        // Accessibility Section
                        Group {
                            Text("Accessibility")
                                .font(.pageTitle)
                            VStack(alignment: .leading) {
                                Text("Text Size")
                                    .font(.bodyText)
                                Slider(
                                    value: Binding(
                                        get: { settings.textSize },
                                        set: { newValue in
                                            settingsController.updateTextSize(
                                                newValue)
                                        }
                                    ),
                                    in: 0.8...1.5,
                                    step: 0.1,
                                    label: { Text("Text Size") }
                                )
                            }
                        }

                        Divider()

                        // Sound Section
                        Group {
                            Text("Sound")
                                .font(.pageTitle)
                            VStack(alignment: .leading) {
                                Text("Music Volume")
                                    .font(.bodyText)
                                Slider(
                                    value: Binding(
                                        get: { settings.musicVolume },
                                        set: { newValue in
                                            settingsController.updateMusicVolume(
                                                newValue)
                                        }
                                    ),
                                    in: 0...1,
                                    step: 0.1,
                                    label: { Text("Music Volume") }
                                )

                                Text("SFX Volume")
                                    .font(.bodyText)
                                Slider(
                                    value: Binding(
                                        get: { settings.sfxVolume },
                                        set: { newValue in
                                            settingsController.updateSFXVolume(
                                                newValue)
                                        }
                                    ),
                                    in: 0...1,
                                    step: 0.1,
                                    label: { Text("SFX Volume") }
                                )
                            }
                        }

                        Divider()

                        // General Section
                        Group {
                            Text("General")
                                .font(.pageTitle)
                            VStack(alignment: .leading) {
                                Text("Language")
                                    .font(.bodyText)
                                Picker(
                                    "Language",
                                    selection: Binding(
                                        get: { settings.selectedLanguage },
                                        set: { newValue in
                                            settingsController.updateLanguage(
                                                newValue)
                                        }
                                    )
                                ) {
                                    ForEach(
                                        settingsController.languages, id: \.self
                                    ) { language in
                                        Text(language)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())

                                Button("Reset Progress") {
                                    settingsController.resetProgress()
                                }
                                .buttonStyle(TriangleSecondaryButton())
                            }
                        }

                        Divider()

                        // App Info Section
                        Group {
                            Text("App Info")
                                .font(.pageTitle)
                            VStack(alignment: .leading) {
                                Text("Version: 1.0.0")
                                    .font(.bodyText)
                                Button("Privacy Policy") {
                                    showPrivacyPolicy = true
                                }
                                .buttonStyle(TriangleSecondaryButton())
                                .sheet(isPresented: $showPrivacyPolicy) {
                                    PrivacyPolicyView(
                                        isPresented: $showPrivacyPolicy)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(ColorTheme.background)
                .toolbarBackground(.hidden, for: .navigationBar)
            } else {
                // Loading state
                ProgressView("Loading...")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let userDataStore = UserDataStore(userId: "previewUser")

        return SettingsView(userDataStore: userDataStore)
            .environmentObject(userDataStore)
            .environmentObject(AuthenticationManager())
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
