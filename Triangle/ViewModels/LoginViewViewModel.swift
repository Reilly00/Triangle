//
//  LoginViewViewModel.swift
//  Triangle
//
//  Created by Josef Zemlicka on 18.01.2025.
//
//  Edited by Ciaran Mullen on 30.01.2025
import SwiftUI
import CloudKit

class LoginViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isiCloudAvailable: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cloudKitManager = CloudKitManager.shared

    init() {
        checkiCloudAvailability()
    }

    func checkiCloudAvailability() {
        cloudKitManager.checkiCloudStatus { [weak self] available in
            DispatchQueue.main.async {
                self?.isiCloudAvailable = available
            }
        }
    }

    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }
        isLoading = true
        // Perform login logic here...
        print("login is true so should bring to exercise selector")
        ExerciseSelectorView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.errorMessage = nil // Clear error after successful login
        }
    }
}
