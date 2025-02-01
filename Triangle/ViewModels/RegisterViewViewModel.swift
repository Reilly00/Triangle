//
//  RegisterViewViewModel.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//
//  Edited By Ciaran Mullen on 30.01.2025.

import SwiftUI

class RegisterViewViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    func register() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            errorMessage = "⚠️ Please fill all fields correctly."
            return
        }

        isLoading = true
        errorMessage = nil

        CloudKitManager.shared.saveUser(username: username, email: email) { success, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    print("✅ Registration successful!")
                    print("SHould now bring to exercise selector")
                    ExerciseSelectorView()
                } else {
                    self.errorMessage = "❌ Registration failed: \(error?.localizedDescription ?? "Unknown error")"
                }
            }
        }
    }
}
