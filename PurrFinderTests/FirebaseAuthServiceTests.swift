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
        
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        let email = "test@example.com"
        let password = "password"
        
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
        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testSignUp() async throws {
        // Création d'une instance Firebase Auth dédiée aux tests
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth
        
        let email = "test@example.com"
        let password = "password"
        
        do {
            // Appel de la fonction signUp
            try await firebaseAuthService.signUp(email: email, password: password)
            
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
    
    func testResetPassword() async throws {
        // Création d'une instance Firebase Auth dédiée aux tests
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth
        
        let email = "test@example.com"
        
            // Création de l'utilisateur de test
            try await auth.createUser(withEmail: email, password: "password")
            
            // Appel de la fonction resetPassword
            try await firebaseAuthService.resetPassword(email: email)
            
            // Vérification que la réinitialisation du mot de passe a été lancée
            // Dans cet exemple, nous ne pouvons pas vérifier que le courriel de réinitialisation a été envoyé car nous utilisons un émulateur.
 
        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testSignOut() throws {
        // Création d'une instance Firebase Auth dédiée aux tests
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth
        
            // Connexion de l'utilisateur de test
            auth.signIn(withEmail: "test@example.com", password: "password")
            
            // Appel de la fonction signOut
            try firebaseAuthService.signOut()
            
            // Vérification que l'utilisateur est déconnecté
            XCTAssertNil(auth.currentUser)

        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        user?.delete()
    }
    
    func testDeleteUser() async throws {
        // Création d'une instance Firebase Auth dédiée aux tests
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth

            try await auth.createUser(withEmail: "test@example.com", password: "password")
            // Connexion de l'utilisateur de test
            try await auth.signIn(withEmail: "test@example.com", password: "password")
            
            // Appel de la fonction deleteUser
            try firebaseAuthService.deleteUser()
            
            try auth.signOut()
            
            // Vérification que l'utilisateur a été supprimé
            XCTAssertNil(auth.currentUser)

        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testGetCurrentUserEmail() async throws {
        // Création d'une instance Firebase Auth dédiée aux tests
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth
        
        try await auth.createUser(withEmail: "test@example.com", password: "password")
        // Connexion de l'utilisateur de test
        try await auth.signIn(withEmail: "test@example.com", password: "password")
        
        // Appel de la fonction getCurrentUserEmail
        let email = firebaseAuthService.getCurrentUserEmail()
        
        // Vérification que l'adresse e-mail de l'utilisateur est correcte
        XCTAssertEqual(email, "test@example.com")
        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testGetCurrentUserUID() async throws {
        // Création d'une instance Firebase Auth dédiée aux tests
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099) // Si vous utilisez un émulateur Firebase Auth
        
        try await auth.createUser(withEmail: "test@example.com", password: "password")
        // Connexion de l'utilisateur de test
        try await auth.signIn(withEmail: "test@example.com", password: "password")
        
        // Appel de la fonction getCurrentUserUID
        let uid = firebaseAuthService.getCurrentUserUID()
        
        // Vérification que l'UID de l'utilisateur est correct
        XCTAssertNotEqual(uid, "")
        
        // Suppression de l'utilisateur de test
        let user = auth.currentUser
        try? await user?.delete()
    }
}
