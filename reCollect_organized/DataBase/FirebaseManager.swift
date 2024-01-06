//
//  FirebaseManager.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 07/09/2023.
//

import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    static let shared = FirebaseManager()
    private let storage = Storage.storage()
    private let firestore = Firestore.firestore()
    
    func saveUserData(name: String, age: String, gender: String, country: String) {
        
        // Get the current user's ID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user found.")
            return
        }
        
        // Reference to the user's document in Firestore
        let userDocumentRef = firestore.collection("users").document(userId)
        
        // Data to save
        let userData: [String: Any] = [
            "name": name,
            "age": age,
            "gender": gender,
            "country": country
        ]
        
        // Set the user's data in Firestore
        userDocumentRef.setData(userData) { error in
            if let error = error {
                print("Failed to save user data:", error.localizedDescription)
            } else {
                print("User data saved successfully!")
            }
        }
    }
    
    
    // This function uploads the local identifier, significance rating, and the actual image
    func uploadPhoto(localIdentifier: String, significanceRating: Int, image: UIImage, timeInterval: TimeInterval, completion: @escaping (Error?) -> Void) {

        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let userId = currentUser.uid
        
        // Convert the UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
            return
        }
        
        // Handle "/" in localIdentifier
        let sanitizedLocalIdentifier = localIdentifier.replacingOccurrences(of: "/", with: "_")
        
        // Set the storage reference with user-specific folder
        let storageRef = storage.reference().child("\(userId)/approved_photos/\(sanitizedLocalIdentifier).jpg")
        
        // Upload the image to Firebase Storage
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // Once the image is uploaded, save the metadata to Firestore under user's document
            let photoData: [String: Any] = [
                "localIdentifier": sanitizedLocalIdentifier,
                "significanceRating": significanceRating,
                "timestamp": timeInterval
            ]
            
            self.firestore.collection("users").document(userId).collection("approved_photos").document(sanitizedLocalIdentifier).setData(photoData) { error in
                completion(error)
            }
        }
    }
    
    // This function updates the significance rating for a specific local identifier
    func updateSignificanceRating(for localIdentifier: String, newRating: Int, completion: @escaping (Error?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let userId = currentUser.uid
        let sanitizedLocalIdentifier = localIdentifier.replacingOccurrences(of: "/", with: "_")
        
        firestore.collection("users").document(userId).collection("approved_photos").document(sanitizedLocalIdentifier).updateData([
            "significanceRating": newRating
        ]) { error in
            completion(error)
        }
    }
    func signOutFromFirebase() {
        do {
            try Auth.auth().signOut()
            
            // Verify sign out
            if Auth.auth().currentUser == nil {
                print("Successfully signed out from Firebase.")
            } else {
                print("Failed to sign out from Firebase.")
            }
            
        } catch let signOutError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func savePhotoComparison(domain: Domain, more: String, less: String,  responseTime: TimeInterval, isSkipped: Bool = false) {
            
        // Ensure the user is authenticated
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated.")
            return
        }
        
        // Replace "/" with "_" in the local identifiers
        let sanitizedMore = more.replacingOccurrences(of: "/", with: "_")
        let sanitizedLess = less.replacingOccurrences(of: "/", with: "_")
        
        // Convert TimeInterval to NSNumber
        let responseTimeNumber = NSNumber(value: responseTime)

        
        // Structure the data
        var comparisonData: [String: Any] = [
            "more": sanitizedMore,
            "less": sanitizedLess,
            "responseTime": responseTimeNumber,
            
        ]
        
        if isSkipped {
                comparisonData["status"] = "Skipped" // Mark as skipped
                comparisonData["equal1"] = sanitizedMore // Indicate equal images (1)
                comparisonData["equal2"] = sanitizedLess // Indicate equal images (2)

                // Update skip count for the domain in Firestore
                let domainRef = firestore.collection("users").document(userId).collection("compairs").document(domain.rawValue)

                // Get the current count and increment it by 1
                domainRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        if var skipCount = document.data()?["skips"] as? Int {
                            skipCount += 1
                            domainRef.updateData(["skips": skipCount])
                        } else {
                            // If the skip count doesn't exist yet, set it to 1
                            domainRef.setData(["skips": 1], merge: true)
                        }
                    } else {
                        print("Document does not exist")
                    }
                }
            }


        
        
        // Set the Firestore reference
        let docRef = firestore.collection("users").document(userId).collection("compairs").document(domain.rawValue)
        
        // Save the comparison data to Firestore
        docRef.setData(["comparisons": FieldValue.arrayUnion([comparisonData])], merge: true) { error in
            if let error = error {
                print("Error saving comparison data: \(error.localizedDescription)")
            } else {
                print("Comparison data saved successfully.")
            }
        }
    }
}

//    func uploadPhoto(localIdentifier: String, significanceRating: Int, image: UIImage, completion: @escaping (Error?) -> Void) {
//
//        // Convert the UIImage to Data
//        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
//            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
//            return
//        }
//
//        // Set the storage reference
//        let storageRef = storage.reference().child("approved_photos/\(localIdentifier).jpg")
//
//        // Upload the image to Firebase Storage
//        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
//            if let error = error {
//                completion(error)
//                return
//            }
//
//            // Once the image is uploaded, save the metadata to Firestore
//            let photoData: [String: Any] = [
//                "localIdentifier": localIdentifier,
//                "significanceRating": significanceRating
//            ]
//
//            self.firestore.collection("approved_photos").document(localIdentifier).setData(photoData) { error in
//                completion(error)
//            }
//        }
//    }
//
//    // This function updates the significance rating for a specific local identifier
//    func updateSignificanceRating(for localIdentifier: String, newRating: Int, completion: @escaping (Error?) -> Void) {
//        firestore.collection("approved_photos").document(localIdentifier).updateData([
//            "significanceRating": newRating
//        ]) { error in
//            completion(error)
//        }
//    }

