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
    @Published var navigateToDashboard: Bool = false  // ✅ Ensures navigation works

    private let cloudKitManager = CloudKitManager.shared

    init() {
        checkiCloudAvailability()
    }

    // ✅ Check iCloud availability
    func checkiCloudAvailability() {
        cloudKitManager.checkiCloudStatus { [weak self] available in
            DispatchQueue.main.async {
                self?.isiCloudAvailable = available
            }
        }
    }

    // ✅ Merged Login Functionality (Temp-Branch + Main)
    func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }
        
        isLoading = true
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false

            if self.username == "user" && self.password == "password" {
                print("✅ Login Successful - Navigating to Dashboard!")
                DispatchQueue.main.async {
                    self.navigateToDashboard = true  // ✅ Enables navigation
                }
            } else {
                print("❌ Invalid Login Attempt")
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid username or password"
                }
            }
        }
    }
}