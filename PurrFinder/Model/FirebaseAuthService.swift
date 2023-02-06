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
    
    func signIn(email: String,
                password: String,
                completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(result!))
        }
    }
    
    func signUp(email: String,
                password: String,
                completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
          if let error = error {
            completion(.failure(error))
            return
          }
          completion(.success(result!))
        }
      }
    
    func resetPassword(email: String,
                completion: @escaping (Result<Void, Error>) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) {(error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func signOut() {
        try! Auth.auth().signOut()
    }
}
