import SwiftUI
import CloudKit

class LoginViewViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isICloudAvailable: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let cloudKitManager = CloudKitManager.shared

    init() {
        checkiCloudAvailability()
    }

    func checkiCloudAvailability() {
        cloudKitManager.checkiCloudStatus { [weak self] available in
            DispatchQueue.main.async {
                self?.isICloudAvailable = available
            }
        }
    }

    func login() {
        guard !username.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }

        isLoading = true

        cloudKitManager.fetchUser(username: username) { exists, record, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                } else if exists {
                    self.errorMessage = nil
                    print("✅ Login successful - Navigating to Exercise Selector")
                    // TODO: Implement navigation logic here
                } else {
                    self.errorMessage = "User not found. Please check your username."
                }
            }
        }
    }
}
