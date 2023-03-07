//
//  FirebaseAuthServiceProtocol.swift
//  PurrFinder
//
//  Created by Yann Rouzaud on 07/03/2023.
//

import Foundation
import Firebase

protocol FirebaseAuthServiceProtocol {
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(email: String, password: String) async throws
    func resetPassword(email: String) async throws
    func signOut() throws
    func deleteUser() throws
    func getCurrentUserEmail() -> String
    func getCurrentUserUID() -> String
}
