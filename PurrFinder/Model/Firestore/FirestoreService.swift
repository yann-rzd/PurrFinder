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
        return db.collection("userData").document(user.id.uuidString)
    }
    
    func saveUserData(user: User) async throws {
        let userData = user.createUserData()
        try await getUserDocumentReference(user: user).setData(myStruct: userData)
        
    }
    
    //    func getUserData(user: User) async throws -> UserDTO {
    //        let docRef = db.collection("userData").document(user.id.uuidString)
    //        print("DOC REF : \(docRef)")
    //        return try await docRef.getDocument(as: UserDTO.self)
    //    }
    //
    
    func getUserData(currentUserEmail: String) async throws -> UserDTO {
        let query = db.collection("userData").whereField("email", isEqualTo: currentUserEmail)
        let querySnapshot = try await query.getDocuments()
        
        guard let document = querySnapshot.documents.first else {
            throw NSError(domain: "UserData", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        let userDict = document.data()
        let userData = try JSONSerialization.data(withJSONObject: userDict, options: [])
        let userDTO = try JSONDecoder().decode(UserDTO.self, from: userData)
        
        return userDTO
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
    
    private let firebaseAuthService = FirebaseAuthService.shared
}
