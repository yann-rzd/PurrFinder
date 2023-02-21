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
        
        func verify() async {
            guard !self.email.isEmpty && !self.pass.isEmpty else {
                self.error = FirebaseAuthServiceError.contentsNotFilledProperly.errorDescription
                self.alert.toggle()
                return
            }
            
            do {
                let result = try await firebaseAuthService.signIn(email: self.email, password: self.pass)
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        func reset() async {
            guard !self.email.isEmpty else {
                self.error = FirebaseAuthServiceError.emailIdIsEmpty.errorDescription
                self.alert.toggle()
                return
            }
            
            do {
                try await firebaseAuthService.resetPassword(email: self.email)
                self.error = FirebaseAuthServiceError.resetPassword.errorDescription
                self.alert.toggle()
            } catch {
                self.error = error.localizedDescription
                self.alert.toggle()
            }
        }
        
        private let firebaseAuthService = FirebaseAuthService.shared
    }
}
