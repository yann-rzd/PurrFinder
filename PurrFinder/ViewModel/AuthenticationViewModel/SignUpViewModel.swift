//
//  SignUpViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import SwiftUI

extension SignUpView {
    @MainActor class SignUpViewModel: ObservableObject {
        @Published var color = Color.black.opacity(0.7)
        @Published var email = ""
        @Published var pass = ""
        @Published var name = ""
        @Published var phone = ""
        @Published var repass = ""
        @Published var visible = false
        @Published var revisible = false
        @Published var alert = false
        @Published var error = ""
        
        var defaultProfileImage = Image("Profile")

        
        func register() async {
            guard self.isValidEmail(email: self.email) else {
                self.error = FirebaseAuthServiceError.emailFormatIsInccorect.errorDescription
                self.alert.toggle()
                return
            }
            
            guard self.isValidPhoneNumber(phone: self.phone) else {
                self.error = FirebaseAuthServiceError.phoneNumberFormatIsIncorrect.errorDescription
                self.alert.toggle()
                return
            }
            
            guard self.isValidUserName(userName: self.name) else {
                self.error = FirebaseAuthServiceError.userNameFormatIsInccorect.errorDescription
                self.alert.toggle()
                return
            }
            
            guard !self.email.isEmpty || !self.name.isEmpty || !self.phone.isEmpty else {
                self.error = FirebaseAuthServiceError.contentsNotFilledProperly.errorDescription
                self.alert.toggle()
                return
            }
            
            guard self.pass == self.repass else {
                self.error = FirebaseAuthServiceError.passwordMismatch.errorDescription
                self.alert.toggle()
                return
            }
            
            do {
                let result = try await firebaseAuthService.signUp(email: self.email, password: self.pass)
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
                self.createUser()
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
                return
            }
        }
        
        /// Create user and save data in FireStore
        private func createUser() {
            Task {
                let uid = firebaseAuthService.getCurrentUserUID()
                
                let user = User(
                    uid: uid,
                    name: self.name,
                    email: self.email,
                    phone: self.phone,
                    profileImage: UIImage(contentsOfFile: "Profile"),
                    locationLatitude: nil,
                    locationLongitude: nil
                )
                
                do {
                    try await fireStoreService.saveUserData(user: user)
                    print("USER UUID : \(user.uid)")
                } catch {
                    
                    print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")
                }
            }
        }
        
        private func isValidPhoneNumber(phone: String) -> Bool {
            let PHONE_REGEX = "^0[1-9](\\s|\\.|\\-)?[0-9]{2}(\\s|\\.|\\-)?[0-9]{2}(\\s|\\.|\\-)?[0-9]{2}(\\s|\\.|\\-)?[0-9]{2}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result = phoneTest.evaluate(with: phone)
            return result
        }
        
        private func isValidEmail(email: String) -> Bool {
            let EMAIL_REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", EMAIL_REGEX)
            let result = emailTest.evaluate(with: email)
            return result
        }
        
        private func isValidUserName(userName: String) -> Bool {
            let USERNAME_REGEX = "^(?:[\\p{L}\\p{M}]|\\d)$|^(?:[\\p{L}\\p{M}]|\\d){25,}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", USERNAME_REGEX)
            let result = phoneTest.evaluate(with: userName)
            return result
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let fireStoreService = FirestoreService.shared
    }
}
