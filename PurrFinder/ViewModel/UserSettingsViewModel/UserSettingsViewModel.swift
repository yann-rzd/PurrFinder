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
        @Published var alert = false
        @Published var error = ""
        
        func deleteUser() async {
            do {
                try await deleteUserData()
                try await deleteUserImage()
                try firebaseAuthService.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                try deleteUserAccount()
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        private func deleteUserData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            try await firestoreService.deleteUserData(uid: userUID)
        }
        
        private func deleteUserAccount() throws {
            try firebaseAuthService.deleteUser()
        }
        
        private func deleteUserImage() async throws {
            try await storageService.deleteImageFromStorage()
        }
        
        private func signOut() throws {
            try firebaseAuthService.signOut()
            UserDefaults.standard.set(false, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
    }
}
