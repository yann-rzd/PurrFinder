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
    
    func updateUserDataNamePhone(userUID: String, name: String, phone: String) async throws {
        let userRef = Firestore.firestore().collection("userData").document(userUID)
        try await userRef.updateData([
            "name": name,
            "phone": phone
        ])
    }
    
    func createPost(post: PostAlert) async throws {
        let postRef = db.collection("postAlertData").document()
        let postDTO = PostAlertDTO(postAlert: post)
        try await postRef.setData(myStruct: postDTO)
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
