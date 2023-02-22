//
//  UserSettingsViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 22/02/2023.
//

import Foundation

extension UserSettingsView {
    @MainActor class UserSettingsViewModel: ObservableObject {
        @Published var alert = false
        @Published var error = ""
        
        func deleteUser() async {
            await deleteUserData()
            await deleteUserImage()
            deleteUserAccount()
        }
        
        private func deleteUserData() async {
            let userUID = firebaseAuthService.getCurrentUserUID()
            
            do {
                try await firestoreService.deleteUserData(uid: userUID)
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        private func deleteUserAccount() {
            firebaseAuthService.deleteUser()
        }
        
        private func deleteUserImage() async {
            do {
                try await storageService.deleteImageFromStorage()
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
    }
}
