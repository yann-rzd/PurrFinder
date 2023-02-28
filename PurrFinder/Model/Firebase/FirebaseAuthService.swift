//
//  FirebaseAuthService.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 06/02/2023.
//

import Foundation
import Firebase

final class FirebaseAuthService {
    
    // MARK: - PATTERN: singleton
    
    static let shared = FirebaseAuthService()
    
    private init() { }
    
    
    // MARK: - INTERNAL: properties
    
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    
    // MARK: - INTERNAL: methods
    
    /// The function allows a user to connect to his account using an email address and a password.
    /// - parameter Email: email of the user.
    /// - parameter Password: password of the user.
    /// - throws: Error
    /// - returns:AuthDataResult object resulting from the authentication operation.
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result
        } catch {
            throw error
        }
    }
    
    /// The function allows a user to signup using an email address and a password.
    /// - parameter Email: email of the user.
    /// - parameter Password: password of the user.
    /// - throws: Error
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
    
    func signOut() throws {
        guard let _ = try? Auth.auth().signOut() else {
            throw FirebaseAuthServiceError.failedToSignOut
        }
    }
    
    func deleteUser() throws {
        guard let user = Auth.auth().currentUser else {
            throw FirebaseAuthServiceError.failedToDeleteUser
        }
        
        user.delete()
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
