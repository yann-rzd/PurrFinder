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
        db.collection("userData").document(user.id.uuidString)
    }
    
    func createUserData(user: User) async throws {
        let userData = user.createUserData()
        try await getUserDocumentReference(user: user).setData(myStruct: userData)
    }
    
    func getUserData(user: User) async throws -> UserDTO {
        let docRef = db.collection("userData").document(user.id.uuidString)
        return try await docRef.getDocument(as: UserDTO.self)
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
