//
//  UserProfileViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import SwiftUI

extension UserProfileView {
    
    @MainActor class UserProfileViewModel: ObservableObject {
        @Published var isEditProfileInformation = false
        @Published var color = Color.black.opacity(0.7)
        
        @Published var name: String = ""
        @Published var email: String = ""
        @Published var phone: String = ""
        @Published var profileImage: UIImage? = nil
        @Published var locationLatitude: String = ""
        @Published var locationLongitude: String = ""
        
        //        var currentUserId = ""
        //
        //        @Published var user = User(
        //            name:  "",
        //            email: "",
        //            phone: "",
        //            profileImage: nil,
        //            locationLatitude: nil,
        //            locationLongitude: nil
        //        )
        
        
        func getUserData() async {
            
//            let user = User(id: UUID(uuidString: "1234")!, name: "", email: "", phone: "", profileImage: nil, locationLatitude: nil, locationLongitude: nil)
//
//            do {
//                let userDTO = try await firestoreService.getUserData(user: user)
//                print("USER DTO : \(userDTO)")
//                self.name = userDTO.name
//                self.email = userDTO.email
//                self.phone = userDTO.phone
//            } catch {
//                print("Erreur lors de la récupération des données utilisateur : \(error.localizedDescription)")
//            }
            
        }
        
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        
        func signOut() {
            firebaseAuthService.signOut()
        }
    }
}

// E068D0E1-6F7D-4E40-9785-23A1C638B3CD





