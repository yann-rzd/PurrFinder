//
//  SignUpViewModel.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import MapKit
import SwiftUI

extension SignUpView {
    @MainActor class SignUpViewModel: ObservableObject {
        @Published var color = Color.black.opacity(0.7)
        @Published var email = ""
        @Published var pass = ""
        @Published var repass = ""
        @Published var visible = false
        @Published var revisible = false
        @Published var alert = false
        @Published var error = ""
        
        func register() {
            if !self.email.isEmpty {
                if self.pass == self.repass {
                    firebaseAuthService.signUp(email: self.email, password: self.pass) { (result) in
                        switch result {
                        case .success(_):
                            UserDefaults.standard.set(true, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
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
        
        private let firebaseAuthService = FirebaseAuthService.shared
    }
}
