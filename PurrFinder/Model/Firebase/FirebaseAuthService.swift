//
//  FirebaseAuthService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import Firebase

final class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    
    private init() { }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result
        } catch {
            throw error
        }
    }
    
    func signUp(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }
    
    func signOut() {
        try! Auth.auth().signOut()
    }
    
    func deleteUser() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user currently logged in"])
        }
        
        do {
            try await user.delete()
        } catch {
            throw error
        }
    }
    
    func getCurrentUserEmail() -> String {
        guard let email = Auth.auth().currentUser?.email else {
            return ""
        }
        return email
    }
    
    func getCurrentUserUID() -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            return ""
        }
        return uid
    }
}
