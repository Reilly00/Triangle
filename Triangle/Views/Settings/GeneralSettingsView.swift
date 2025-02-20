//
//  GeneralSettingsView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 20.02.2025.
//

import SwiftUI

struct GeneralSettingsView: View {
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("General Settings")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.top, 40)

                VStack(alignment: .leading, spacing: 20) {
                    Text("Language")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))

                    Picker("Language", selection: $settings.selectedLanguage) {
                        ForEach(settings.languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 200)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Button(action: {
                        print("Reset Progress button tapped")
                    }) {
                        Text("Reset Progress")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
                .frame(maxWidth: 400)
                .background(Color(UIColor.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("General")
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
            .previewDevice("iPad Pro 11-inch")
            .previewInterfaceOrientation(.landscapeLeft)
            .environmentObject(SettingsViewModel())
    }
}
