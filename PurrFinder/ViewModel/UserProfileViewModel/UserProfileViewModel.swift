//
//  UserProfileViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import SwiftUI
import Firebase

extension UserProfileView {
    
    @MainActor class UserProfileViewModel: ObservableObject {
        @Published var isEditProfileInformation = false
        @Published var color = Color.black.opacity(0.7)
        
        @Published var name: String = ""
        @Published var email: String = ""
        @Published var phone: String = ""
        @Published var profileImage: UIImage?
        @Published var locationLatitude: String? = nil
        @Published var locationLongitude: String? = nil
        
                
        func getUserData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()

            let userDTO = try await firestoreService.getUserData(userUID: userUID)
            name = userDTO.name
            phone = userDTO.phone
            
            try await getProfileImage()
        }
        
        private func getProfileImage() async throws {
            self.profileImage = try await storageService.downloadProfileImage()
        }
        
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        
        func signOut() {
            firebaseAuthService.signOut()
        }
    }
}





