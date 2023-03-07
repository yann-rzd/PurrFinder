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

    override func setUp() {
        super.setUp()
        firebaseAuthService = FirebaseAuthService()
    }
    
    func testSignIn() async throws {
        let authService = FirebaseAuthServiceMock()
        let result = try await authService.signIn(email: "test@example.com", password: "password")
        XCTAssertNotNil(result.user)
    }

//    func testSignIn() async throws {
//
//        let auth = Auth.auth()
//        auth.useEmulator(withHost: "localhost", port: 9099)
//        let email = "test@example.com"
//        let password = "password"
//
//        do {
//            // Création de l'utilisateur de test
//            try await auth.createUser(withEmail: email, password: password)
//
//            // Appel de la fonction signIn
//            let result = try await firebaseAuthService.signIn(email: email, password: password)
//
//            // Vérification que l'utilisateur est connecté
//            let user = result.user
//            XCTAssertNotNil(user)
//            XCTAssertEqual(user.email, email)
//        } catch {
//            XCTFail("La connexion a échoué avec l'erreur : \(error.localizedDescription)")
//        }
//
//        // Suppression de l'utilisateur de test
//        let user = auth.currentUser
//        try? await user?.delete()
//    }

//    func testSignUp() async throws {
//        // Création d'une instance Firebase Auth dédiée aux tests
//        let auth = Auth.auth()
//        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth
//
//        let email = "test@example.com"
//        let password = "password"
//
//        do {
//            // Appel de la fonction signUp
//            try await auth.createUser(withEmail: email, password: password)
//
//            // Vérification que l'utilisateur a bien été créé dans Firebase
//            let user = auth.currentUser
//            XCTAssertNotNil(user)
//            XCTAssertEqual(user?.email, email)
//        } catch {
//            XCTFail("L'inscription a échoué avec l'erreur : \(error.localizedDescription)")
//        }
//
//        // Suppression de l'utilisateur de test
//        let user = auth.currentUser
//        try? await user?.delete()
//    }
}
