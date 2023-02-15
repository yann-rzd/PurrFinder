//
//  SignUpViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import CoreLocation

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
        
        func register() {
            if !self.email.isEmpty && !self.name.isEmpty && !self.phone.isEmpty {
                if self.pass == self.repass {
                    firebaseAuthService.signUp(email: self.email, password: self.pass) { (result) in
                        switch result {
                        case .success(_):
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            
                            self.createUser()
                            
                        case .failure(let error):
                            self.error = error.localizedDescription
                            self.alert.toggle()
                            return
                        }
                    }
                } else {
                    self.error = AuthenticationServiceError.passwordMismatch.errorDescription
                    self.alert.toggle()
                }
            } else {
                self.error = AuthenticationServiceError.contentsNotFilledProperly.errorDescription
                self.alert.toggle()
            }
        }
        
        private func createUser() {
            self.fireStoreService.createUser(user: User(name: self.name,
                                                        email: self.email,
                                                        phone: self.phone,
                                                        profileImage: nil,
                                                        location: nil)) { error in
                if let error = error {
                    // Gestion de l'erreur
                    print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")
                } else {
                    // Traitement réussi
                    print("Utilisateur créé avec succès !")
                }
            }
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
        private let fireStoreService = FireStoreService.shared
    }
}
