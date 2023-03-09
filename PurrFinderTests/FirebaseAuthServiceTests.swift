//
//  FirestoreServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 01/03/2023.
//

import XCTest
@testable import PurrFinder
import Firebase

final class FirebaseAuthServiceTests: XCTestCase {
    
    var firebaseAuthService: FirebaseAuthService!
    var auth: Auth!
    var email: String!
    var password: String!
    
    override func setUp() {
        super.setUp()
        firebaseAuthService = FirebaseAuthService()
        auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        email = "test@example.com"
        password = "password"
    }
    
    override func tearDown() {
        super.tearDown()
        let user = auth.currentUser
        user?.delete()
    }
    
    func testSignIn() async throws {
        
        do {
            // Création de l'utilisateur de test
            try await auth.createUser(withEmail: email, password: password)
            
            // Appel de la fonction signIn
            let result = try await firebaseAuthService.signIn(email: email, password: password)
            
            // Vérification que l'utilisateur est connecté
            let user = result.user
            XCTAssertNotNil(user)
            XCTAssertEqual(user.email, email)
        } catch {
            XCTFail("La connexion a échoué avec l'erreur : \(error.localizedDescription)")
        }
    }
    
    
    func testSignUp() async throws {
        
        do {
            // Appel de la fonction signUp
            try await auth.createUser(withEmail: email, password: password)
            
            // Vérification que l'utilisateur a bien été créé dans Firebase
            let user = auth.currentUser
            XCTAssertNotNil(user)
            XCTAssertEqual(user?.email, email)
        } catch {
            XCTFail("L'inscription a échoué avec l'erreur : \(error.localizedDescription)")
        }
        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        try? await user?.delete()
    }
}
