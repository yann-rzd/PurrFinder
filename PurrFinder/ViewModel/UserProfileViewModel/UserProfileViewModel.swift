//
//  UserProfileViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

extension UserProfileView {
    
    @MainActor class UserProfileViewModel: ObservableObject {
        
        private var db = Firestore.firestore()
        @Published var profileName = ""
        @Published var phone = ""
        
        
        
        func getUserInfo(completion: @escaping (String, String) -> Void) {
            guard let userId = Auth.auth().currentUser?.uid else {
                return
            }
            let docRef = Firestore.firestore().collection("users").document(userId)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let name = document.data()?["name"] as? String, let phoneNumber = document.data()?["phoneNumber"] as? String {
                        completion(name, phoneNumber)
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
        
        
        
        func signOut() {
            firebaseAuthService.signOut()
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
    }
}
