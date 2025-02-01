//
//  CloudKitManager.swift
//  Triangle
//
//  Created by Ciaran Mullen on 30/01/2025.
//
import CloudKit

class CloudKitManager {
    static let shared = CloudKitManager() // Singleton instance

    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    /// Check if iCloud is available
    func checkiCloudStatus(completion: @escaping (Bool) -> Void) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                switch status {
                case .available:
                    print("✅ iCloud Available")
                    completion(true)
                case .noAccount:
                    print("⚠️ No iCloud Account")
                    completion(false)
                case .restricted:
                    print("⛔ iCloud Restricted")
                    completion(false)
                case .couldNotDetermine:
                    print("❓ iCloud Status Unknown")
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
    }

    /// Fetch an existing user from CloudKit (for login verification)
    func fetchUser(username: String, completion: @escaping (Bool, CKRecord?, Error?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "TriangleUsers", predicate: predicate)

        self.privateDatabase.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("⚠️ Error fetching user: \(error.localizedDescription)")
                    completion(false, nil, error)
                } else if let record = records?.first {
                    print("✅ User found: \(record["username"] ?? "Unknown")")
                    completion(true, record, nil)
                } else {
                    print("⚠️ User not found")
                    completion(false, nil, nil)
                }
            }
        }
    }

    /// Save a new user to CloudKit (Prevents duplicate usernames)
    func saveUser(username: String, email: String, completion: @escaping (Bool, Error?) -> Void) {
        // Step 1: Check if the username already exists
        fetchUser(username: username) { exists, _, error in
            if let error = error {
                completion(false, error)
                return
            }

            if exists {
                let usernameTakenError = NSError(domain: "CloudKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username is already taken."])
                completion(false, usernameTakenError)
                return
            }

            // Step 2: Username is available, create a new CloudKit record
            let record = CKRecord(recordType: "TriangleUsers")
            record["username"] = username as CKRecordValue
            record["email"] = email as CKRecordValue

            self.privateDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error saving user: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("✅ User saved: \(username)")
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
