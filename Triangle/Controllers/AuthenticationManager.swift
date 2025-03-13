//
//  AuthenticationManager.swift
//  Triangle
//
//  Created by Josef Zemlicka on 05.03.2025.
//

import SwiftUI

// Object that holds the currently logged user so that we can automatically load relevant settings, progress etc...
// Not the safest approach but we are in the hardcode zone rn.
final class AuthenticationManager: ObservableObject {
    @Published var currentUserId: String? {
        didSet {
            if let userId = currentUserId {
                UserDefaults.standard.set(userId, forKey: "currentUserId")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUserId")
            }
        }
    }

    init() {
        if let savedUser = UserDefaults.standard.string(forKey: "currentUserId")
        {
            self.currentUserId = savedUser
        }
    }

    func login(withUserId userId: String) {
        self.currentUserId = userId
    }

    func logout(userDataStore: UserDataStore) {
        currentUserId = nil
        userDataStore.logout()
        print("AuthenticationManager: User logged out.")
    }
}
