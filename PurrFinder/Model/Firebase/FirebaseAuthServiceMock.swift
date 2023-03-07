//
//  FirebaseAuthServiceMock.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 06/03/2023.
//

import Foundation
@testable import PurrFinder
import Firebase

class FirebaseAuthServiceMock: FirebaseAuthServiceProtocol {
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        let auth = Auth.auth()
        let userCredential = try await auth.signIn(withEmail: email, password: password)
        return userCredential
    }
    
    func signUp(email: String, password: String) async throws {
        // code
    }
    
    func resetPassword(email: String) async throws {
        // code
    }
    
    func signOut() throws {
        // code
    }
    
    func deleteUser() throws {
        // code
    }
    
    func getCurrentUserEmail() -> String {
        // code
        return ""
    }
    
    func getCurrentUserUID() -> String {
        // code
        return ""
    }
}
