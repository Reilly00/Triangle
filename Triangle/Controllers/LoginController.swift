//
//  LoginController.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import Foundation
import SwiftUI

class LoginController: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var navigateToDashboard: Bool = false

    var authManager: AuthenticationManager?

    func login() {
        errorMessage = nil
        isLoading = true

        // Simulate an asynchronous login -> no backend :(
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let defaults = UserDefaults.standard
            let registeredUsers =
                defaults.dictionary(forKey: "registeredUsers")
                as? [String: [String: String]] ?? [:]

            guard let userData = registeredUsers[self.username] else {
                self.errorMessage = "User not found."
                self.isLoading = false
                return
            }

            if let storedPassword = userData["password"],
                storedPassword == self.password
            {
                self.authManager?.login(withUserId: self.username)
                self.navigateToDashboard = true
                print(self.authManager?.currentUserId ?? "No user logged in")
            } else {
                self.errorMessage = "Invalid password."
            }
            self.isLoading = false
        }
    }
}
