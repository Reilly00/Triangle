//
//  RegisterController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation
import SwiftUI

class RegisterController: ObservableObject {
    // Input field states
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // UI states
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var navigateToDashboard: Bool = false
    
    func register() {
        errorMessage = nil
        
        
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true
        
        // Simulate an asynchronous registration -> no backend :(
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let defaults = UserDefaults.standard
            // Retrieve current registered users dictionary from UserDefaults, or create a new one if none exists
            var registeredUsers = defaults.dictionary(forKey: "registeredUsers") as? [String: [String: String]] ?? [:]
            
            if registeredUsers[self.username] != nil {
                self.errorMessage = "Username already taken."
                self.isLoading = false
                return
            }
            
            registeredUsers[self.username] = [
                "email": self.email,
                "password": self.password
            ]
            defaults.set(registeredUsers, forKey: "registeredUsers")
            
            self.isLoading = false
            self.navigateToDashboard = true
        }
    }
    
    // Bunch of regex I use everytime, not that it matters
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let regex = NSPredicate(format:"SELF MATCHES %@", pattern)
        return regex.evaluate(with: email)
    }
}
