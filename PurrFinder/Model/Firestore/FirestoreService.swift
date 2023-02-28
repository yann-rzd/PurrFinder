//
//  FireStoreService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import FirebaseFirestore
import Firebase

final class FirestoreService {
    
    // MARK: - PATTERN: singleton
    
    static let shared = FirestoreService()
    
    private init() {}
    
    
    // MARK: - INTERNAL: methods
    
    func saveUserData(user: User) async throws {
        let userData = user.createUserData()
        try await getUserDocumentReference(user: user).setData(myStruct: userData)
    }
    
    func getUserData(userUID: String) async throws -> UserDTO {
        let docRef = db.collection("userData").document(userUID)
        let userDTOResponse = try await docRef.getDocument(as: UserDTO.self)

        return userDTOResponse.1
    }
    
    func deleteUserData(uid: String) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("userData").document(uid)
        let snapshot = try await userRef.getDocument()
        guard snapshot.exists else {
            throw NSError(domain: "UserNotFound", code: 404, userInfo: nil)
        }
        try await userRef.delete()
    }
    
    func updateUserDataNamePhone(userUID: String, name: String, phone: String) async throws {
        let userRef = Firestore.firestore().collection("userData").document(userUID)
        try await userRef.updateData([
            "name": name,
            "phone": phone
        ])
    }
    
    func updateUserLocationData(userUID: String, latitude: String, longitude: String) async throws {
        let userRef = Firestore.firestore().collection("userData").document(userUID)
        try await userRef.updateData([
            "locationLatitude": latitude,
            "locationLongitude": longitude
        ])
    }
    
    func createPostAlert(post: PostAlert, userUID: String) async throws {
        let postRef = db.collection("postAlertData").document(userUID)
        let postAlertData = post.createPostAlertData()
        try await postRef.setData(myStruct: postAlertData)
    }
    
    func getPostAlertData(userUID: String) async throws -> PostAlertDTO {
        let docRef = db.collection("postAlertData").document(userUID)
        let postAlertDTOResponse = try await docRef.getDocument(as: PostAlertDTO.self)
        
        let id = postAlertDTOResponse.0
        return postAlertDTOResponse.1
    }
    
    func checkIfAlertInProgress(userUID: String) async -> Bool {
        let collectionRef = db.collection("postAlertData")
        
        do {
            let querySnapshot = try await collectionRef.whereField("ownerUid", isEqualTo: userUID).getDocuments()
            
            if querySnapshot.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Erreur lors de la récupération des documents: \(error.localizedDescription)")
            return false
        }
    }
    
    func deletePostAlert(userUID: String) async throws {
        let postAlertRef = db.collection("postAlertData").document(userUID)
        let snapshot = try await postAlertRef.getDocument()
        guard snapshot.exists else {
            throw NSError(domain: "PostAlertNotFound", code: 404, userInfo: nil)
        }
        try await postAlertRef.delete()
    }
    
    
    // MARK: - PRIVATE: properties
    
    private let db = Firestore.firestore()
    
    
    // MARK: - PRIVATE: methods
    
    private func getUserDocumentReference(user: User) -> DocumentReference {
        return db.collection("userData").document(user.uid)
    }
}
