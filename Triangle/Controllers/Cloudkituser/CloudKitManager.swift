//
//  CloudKitManager.swift
//  Triangle
//
//  Created by Ciaran Mullen on 30/01/2025.
//
import CloudKit
import CryptoKit

class CloudKitManager {
    static let shared = CloudKitManager()
    
    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase

    /// Generates a random salt for password hashing
    private func generateSalt() -> String {
        let saltData = Data((0..<16).map { _ in UInt8.random(in: 0...255) })
        return saltData.base64EncodedString()
    }

    /// Hashes a password using SHA-256 with a salt
    private func hashPassword(password: String, salt: String) -> String {
        let saltedPassword = password + salt
        let hashedData = SHA256.hash(data: saltedPassword.data(using: .utf8)!)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }

    /// Save a new user to CloudKit with a hashed password
    func saveUser(username: String, email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        fetchUserForRegistration(username: username) { exists, _, error in
            if let error = error {
                completion(false, error)
                return
            }

            if exists {
                let error = NSError(domain: "CloudKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Username is already taken."])
                completion(false, error)
                return
            }

            // Generate a salt and hash the password
            let salt = self.generateSalt()
            let hashedPassword = self.hashPassword(password: password, salt: salt)

            let record = CKRecord(recordType: "TriangleUsers")
            record["username"] = username as CKRecordValue
            record["email"] = email as CKRecordValue
            record["passwordHash"] = hashedPassword as CKRecordValue
            record["salt"] = salt as CKRecordValue

            self.privateDatabase.save(record) { _, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error saving user: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("✅ User registered successfully")
                        completion(true, nil)
                    }
                }
            }
        }
    }

    /// Fetch user for **registration** to check if the username exists (does NOT require password)
    func fetchUserForRegistration(username: String, completion: @escaping (Bool, CKRecord?, Error?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "TriangleUsers", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1

        var fetchedRecord: CKRecord?

        queryOperation.recordMatchedBlock = { _, result in
            switch result {
            case .success(let record):
                fetchedRecord = record
            case .failure(let error):
                print("⚠️ Error fetching user: \(error.localizedDescription)")
                completion(false, nil, error)
            }
        }

        queryOperation.queryResultBlock = { _ in
            DispatchQueue.main.async {
                if let record = fetchedRecord {
                    print("✅ Username exists: \(record["username"] ?? "Unknown")")
                    completion(true, record, nil)
                } else {
                    print("⚠️ Username not found")
                    completion(false, nil, nil)
                }
            }
        }

        privateDatabase.add(queryOperation)
    }

    /// Fetch user for **login** (requires username + password)
    func fetchUserForLogin(username: String, password: String, completion: @escaping (Bool, CKRecord?, Error?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "TriangleUsers", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var fetchedRecord: CKRecord?

        queryOperation.recordMatchedBlock = { _, result in
            switch result {
            case .success(let record):
                fetchedRecord = record
            case .failure(let error):
                print("⚠️ Error fetching user: \(error.localizedDescription)")
                completion(false, nil, error)
            }
        }

        queryOperation.queryResultBlock = { _ in
            DispatchQueue.main.async {
                if let record = fetchedRecord,
                   let storedHash = record["passwordHash"] as? String,
                   let salt = record["salt"] as? String {
                    
                    let hashedInputPassword = self.hashPassword(password: password, salt: salt)

                    if hashedInputPassword == storedHash {
                        print("✅ Password correct - User authenticated")
                        completion(true, record, nil)
                    } else {
                        print("❌ Incorrect password")
                        completion(false, nil, nil)
                    }
                } else {
                    print("⚠️ User not found or missing credentials")
                    completion(false, nil, nil)
                }
            }
        }

        privateDatabase.add(queryOperation)
    }

    func saveUserProgress(username: String, level: Int, score: Int, completion: @escaping (Bool, Error?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "UserProgress", predicate: predicate)
        
        privateDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("❌ Error fetching progress: \(error.localizedDescription)")
                completion(false, error)
                return
            }

            let record: CKRecord
            if let existingRecord = results?.first {
                record = existingRecord
            } else {
                record = CKRecord(recordType: "UserProgress")
                record["username"] = username as CKRecordValue
            }

            record["level"] = level as CKRecordValue
            record["score"] = score as CKRecordValue
            record["timestamp"] = Date() as CKRecordValue

            self.privateDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("❌ Error saving progress: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("✅ Progress saved successfully for \(username)")
                        completion(true, nil)
                    }
                }
            }
        }
    }
    func loadUserProgress(username: String, completion: @escaping (Int?, Int?, Error?) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        let query = CKQuery(recordType: "UserProgress", predicate: predicate)

        privateDatabase.perform(query, inZoneWith: nil) { results, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error loading progress: \(error.localizedDescription)")
                    completion(nil, nil, error)
                    return
                }

                if let record = results?.first,
                   let level = record["level"] as? Int,
                   let score = record["score"] as? Int {
                    print("✅ Loaded progress - Level: \(level), Score: \(score)")
                    completion(level, score, nil)
                } else {
                    print("⚠️ No progress found for \(username)")
                    completion(nil, nil, nil)
                }
            }
        }
    }

    func checkiCloudStatus(completion: @escaping (Bool) -> Void) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error checking iCloud status: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                switch status {
                case .available:
                    print("✅ iCloud Available")
                    completion(true)
                case .noAccount:
                    print("⚠️ No iCloud Account - Please sign in to iCloud.")
                    completion(false)
                case .restricted:
                    print("⛔ iCloud is Restricted - Check parental controls or MDM settings.")
                    completion(false)
                case .couldNotDetermine:
                    print("❓ iCloud Status Unknown - Try again later.")
                    completion(false)
                case .temporarilyUnavailable:
                    print("❓ iCloud Status Unknown - Try again later.")
                    completion(false)
                @unknown default: // ✅ Required for Swift 6
                    print("🚨 Unknown iCloud status - Future case.")
                    completion(false)
                }
            }
        }
    }
}
