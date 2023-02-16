//
//  LoginViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import MapKit
import SwiftUI

extension LoginView {
    @MainActor class LoginViewModel: ObservableObject {
        @Published var color = Color.black.opacity(0.7)
        @Published var email = ""
        @Published var pass = ""
        @Published var visible = false
        @Published var alert = false
        @Published var error = ""
        
        func verify() {
            if !self.email.isEmpty && !self.pass.isEmpty {
                firebaseAuthService.signIn(email: self.email, password: self.pass) { (result) in
                    switch result {
                    case .success(_):
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    case .failure(let error) :
                        self.error = error.localizedDescription
                        self.alert.toggle()
                        return
                        
                    }
                }
            } else {
                self.error = FirebaseAuthServiceError.contentsNotFilledProperly.errorDescription
                self.alert.toggle()
            }
            
        }
        
        func reset() {
            if !self.email.isEmpty {
                firebaseAuthService.resetPassword(email: self.email) { (result) in
                    switch result {
                    case .success:
                        self.error = FirebaseAuthServiceError.resetPassword.errorDescription
                        self.alert.toggle()
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.alert.toggle()
                        return
                    }
                }
            } else {
                self.error = FirebaseAuthServiceError.emailIdIsEmpty.errorDescription
                self.alert.toggle()
            }
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
    }
}
