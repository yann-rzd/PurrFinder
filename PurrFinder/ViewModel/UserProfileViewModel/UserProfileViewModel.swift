//
//  UserProfileViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import MapKit
import Firebase

extension UserProfileView {
    @MainActor class UserProfileViewModel: ObservableObject {
        func signOut() {
            firebaseAuthService.signOut()
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
    }
}
