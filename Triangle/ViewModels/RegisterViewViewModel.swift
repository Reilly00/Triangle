import SwiftUI
import CloudKit

class RegisterViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cloudKitManager = CloudKitManager.shared

    func register() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        isLoading = true

        // First, check if the username is already taken
        cloudKitManager.fetchUser(username: username) { exists, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Error checking username: \(error.localizedDescription)"
                }
                return
            }

            if exists {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Username is already taken. Choose another."
                }
                return
            }

            // Username is available, proceed with registration
            self.cloudKitManager.saveUser(username: self.username, email: self.email) { success, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = "Registration failed: \(error.localizedDescription)"
                    } else {
                        print("✅ Registration successful!")
                        self.errorMessage = nil
                        // TODO: Implement navigation logic here
                    }
                }
            }
        }
    }
}
