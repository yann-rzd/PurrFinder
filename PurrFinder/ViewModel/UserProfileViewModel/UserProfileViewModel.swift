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
        @Published var alert = false
        @Published var error = ""
        
                
        func getUserData() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()

            let userDTO = try await firestoreService.getUserData(userUID: userUID)
            name = userDTO.name
            phone = userDTO.phone
            
            try await getProfileImage()
        }
        
        func saveUserDataNamePhone() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            
            guard !self.name.isEmpty && !self.phone.isEmpty else {
                self.error = FirebaseAuthServiceError.contentsNotFilledProperly.errorDescription
                self.alert.toggle()
                return
            }
            
            guard !self.name.isEmpty || !self.phone.isEmpty else {
                self.error = FirebaseAuthServiceError.contentsNotFilledProperly.errorDescription
                self.alert.toggle()
                return
            }
            
            guard self.isValidPhoneNumber(phone: self.phone) else {
                let userDTO = try await firestoreService.getUserData(userUID: userUID)
                phone = userDTO.phone
                
                self.error = FirebaseAuthServiceError.phoneNumberFormatIsIncorrect.errorDescription
                self.alert.toggle()
                return
            }
            
            guard self.isValidUserName(userName: self.name) else {
                let userDTO = try await firestoreService.getUserData(userUID: userUID)
                name = userDTO.name
                
                self.error = FirebaseAuthServiceError.userNameFormatIsInccorect.errorDescription
                self.alert.toggle()
                return
            }
            
            do {
                try await firestoreService.updateUserDataNamePhone(userUID: userUID, name: self.name, phone: self.phone)
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        func signOut() {
            do {
                try firebaseAuthService.signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let firestoreService = FirestoreService.shared
        private let storageService = StorageService.shared
        
        
        private func isValidPhoneNumber(phone: String) -> Bool {
            let PHONE_REGEX = "^0[1-9](\\s|\\.|\\-)?[0-9]{2}(\\s|\\.|\\-)?[0-9]{2}(\\s|\\.|\\-)?[0-9]{2}(\\s|\\.|\\-)?[0-9]{2}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result = phoneTest.evaluate(with: phone)
            return result
        }
        
        private func isValidUserName(userName: String) -> Bool {
            let USERNAME_REGEX = "^[0-9a-zA-Z\\_]{2,18}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", USERNAME_REGEX)
            let result = phoneTest.evaluate(with: userName)
            return result
        }
        
        private func getProfileImage() async throws {
            let userUID = firebaseAuthService.getCurrentUserUID()
            self.profileImage = try await storageService.downloadProfileImage(userUID: userUID)
        }
    }
}






