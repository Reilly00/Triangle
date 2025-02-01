//
//  SettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 23.01.2025.
//

import SwiftUI

// TODO: Implement the logic for buttons and sliders
// Currently the sliders and buttons just print out the new values which is fine for now

struct SettingsView: View {
    @State private var musicVolume: Double = 0.5
    @State private var sfxVolume: Double = 0.5
    @State private var textSize: Double = 1.0
    @State private var selectedLanguage: String = "English"
    @State private var showPrivacyPolicy: Bool = false

    let languages = ["English", "Czech", "Spanish"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Account
                    Group {
                        Text("Account")
                            .font(.montserratHeadline)
                        Button("Update Email") {
                            print("Update Email button tapped")
                        }
                        .buttonStyle(TrianglePrimaryButton())

                        Button("Change Password") {
                            print("Change Password button tapped")
                        }
                        .buttonStyle(TrianglePrimaryButton())
                    }

                    Divider()

                    // Accessibility
                    Group {
                        Text("Accessibility")
                            .font(.montserratHeadline)

                        VStack(alignment: .leading) {
                            Text("Text Size")
                                .font(.montserratBody)
                            Slider(value: $textSize, in: 0.8...1.5, step: 0.1) {
                                Text("Text Size")
                            }
                            .onChange(of: textSize, initial: true) { oldValue, newValue in
                                print("Text size updated to: \(newValue)")
                            }
                        }
                    }

                    Divider()

                    // Sound
                    Group {
                        Text("Sound")
                            .font(.montserratHeadline)

                        VStack(alignment: .leading) {
                            Text("Music Volume")
                                .font(.montserratBody)
                            Slider(value: $musicVolume, in: 0...1, step: 0.1) {
                                Text("Music Volume")
                            }
                            .onChange(of: musicVolume, initial: true) { oldValue, newValue in
                                print("Music volume updated to: \(newValue)")
                            }

                            Text("SFX Volume")
                                .font(.montserratBody)
                            Slider(value: $sfxVolume, in: 0...1, step: 0.1) {
                                Text("SFX Volume")
                            }
                            .onChange(of: sfxVolume, initial: true) { oldValue, newValue in
                                print("SFX volume updated to: \(newValue)")
                            }
                        }
                    }

                    Divider()

                    // General
                    Group {
                        Text("General")
                            .font(.montserratHeadline)

                        VStack(alignment: .leading) {
                            Text("Language")
                                .font(.montserratBody)
                            Picker("Language", selection: $selectedLanguage) {
                                ForEach(languages, id: \ .self) { language in
                                    Text(language)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedLanguage, initial: true) { oldValue, newValue in
                                print("Language changed to: \(newValue)")
                            }

                            Button("Reset Progress") {
                                print("Reset Progress button tapped")
                            }
                            .buttonStyle(TriangleSecondaryButton())
                        }
                    }

                    Divider()

                    // App Info
                    Group {
                        Text("App Info")
                            .font(.montserratHeadline)

                        VStack(alignment: .leading) {
                            Text("Version: 1.0.0")
                                .font(.montserratBody)
                            Button("Privacy Policy") {
                                print("Privacy Policy button tapped")
                                showPrivacyPolicy = true
                            }
                            .buttonStyle(TriangleSecondaryButton())
                            .sheet(isPresented: $showPrivacyPolicy) {
                                PrivacyPolicyView(isPresented: $showPrivacyPolicy)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(ColorTheme.background)
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

