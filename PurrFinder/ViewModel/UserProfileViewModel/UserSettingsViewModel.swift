//
//  UserSettingsViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import Foundation

extension UserSettingsView {
    @MainActor
    class UserSettingsViewModel: ObservableObject {
        
        // MARK: - INTERNAL: properties
        
        @Published var alert = false
        @Published var error = ""
        
        
        // MARK: - INTERNAL: methods
        
        func deleteUser() async {
            do {
                try await deleteUserData()
                try await deleteUserImage()
                try deleteUserAccount()
                try firebaseAuthService.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        // MARK: - PRIVATE: properties
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        
        
        // MARK: - PRIVATE: methods
        
        private func deleteUserData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            try await firestoreService.deleteUserData(uid: userUID)
        }
        
        private func deleteUserAccount() throws {
            try firebaseAuthService.deleteUser()
        }
        
        private func deleteUserImage() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            try await storageService.deleteUserProfileImageFromStorage(userUID: userUID)
        }
        
        private func signOut() throws {
            try firebaseAuthService.signOut()
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            
        }
    }
}
