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
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private init() {}
    
    
    private func getUserDocumentReference(user: User) -> DocumentReference {
        return db.collection("userData").document(user.uid)
    }
    
    func saveUserData(user: User) async throws {
        let userData = user.createUserData()
        try await getUserDocumentReference(user: user).setData(myStruct: userData)
        
    }
    
    func getUserData(userUID: String) async throws -> UserDTO {
        let docRef = db.collection("userData").document(userUID)
        let userDTOResponse = try await docRef.getDocument(as: UserDTO.self)
        
        let id = userDTOResponse.0
        print(id)
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
    
    func createPost(post: PostAlert) async throws {
        let postRef = db.collection("postAlertData").document()
        let postAlertData = post.createPostAlertData()
        try await postRef.setData(myStruct: postAlertData)
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
    
    func deletePost(postId: String, completion: @escaping (Error?) -> Void) {
        let postRef = db.collection("postAlertData").document(postId)
        postRef.delete { (error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
