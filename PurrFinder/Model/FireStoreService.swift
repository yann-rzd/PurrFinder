//
//  FireStoreService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/02/2023.
//

import Foundation
import FirebaseFirestore


final class FireStoreService {
    static let shared = FireStoreService()
    let db = Firestore.firestore()
    
    private init() {}
    
    func createUser(user: User, completion: @escaping (Error?) -> Void) {
        
        let data: [String: Any] = ["name": user.name,
            "email": user.email,
            "phone": user.phone]
        
        db.collection("users").document(user.id.uuidString).setData(data) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    func createPost(post: PostAlert, completion: @escaping (Error?) -> Void) {
        let postRef = db.collection("posts").document()
        
        let data: [String: Any] = [
            "animalName": post.animal.name,
            "animalType": post.animal.type,
            "locationLatitude": post.location.latitude,
            "locationLongitude": post.location.longitude,
            "date": post.date,
            "userId": post.user.id
        ]
        
        postRef.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(postRef.documentID)")
            }
        }
        
        let notification = Notification()
        notification.scheduleNotification(
            animalLocation: post.location,
            animalName: post.animal.name,
            animalDescription: post.description
        )
    }
    
    func deletePost(postId: String, completion: @escaping (Error?) -> Void) {
        let postRef = db.collection("posts").document(postId)
        postRef.delete { (error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
