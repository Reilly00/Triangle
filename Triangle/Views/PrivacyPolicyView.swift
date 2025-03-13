//
//  PrivacyPolicyView.swift
//  Triangle
//
//  Created by Josef Zemlicka on 23.01.2025.
//
import SwiftUI

// TODO: Add privacy policy text and fix UI

struct PrivacyPolicyView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.pageTitle)
                .padding()

            ScrollView {
                Text("Here is the detailed privacy policy...")
                    .font(.bodyText)
                    .padding()
            }

            Button("Close") {
                isPresented = false
            }
            .buttonStyle(TrianglePrimaryButton())
            .padding()
        }
    }
}
