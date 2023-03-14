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
    func testGivenUserLogInInformation_WhenSignIn_ThenUserLoggedIn() {
        
    }
    func testGivenUserLogInInformation_WhenSignIn_ThenUserLoggedIn() async throws {
        
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        let email = "test@example.com"
        let password = "password"
        
        do {
            // Creation of the test user
            try await auth.createUser(withEmail: email, password: password)
            
            // Calling the signIn function
            let result = try await firebaseAuthService.signIn(email: email, password: password)
            
            // Verification that the user is logged in
            let user = result.user
            XCTAssertNotNil(user)
            XCTAssertEqual(user.email, email)
        } catch {
            XCTFail("La connexion a échoué avec l'erreur : \(error.localizedDescription)")
        }
        
        // Deleting the test user
        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testGivenUserLogInInformation_WhenSignUp_ThenUserSignedUp() async throws {
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        
        let email = "test@example.com"
        let password = "password"
        
        do {
            try await firebaseAuthService.signUp(email: email, password: password)
            let user = auth.currentUser
            XCTAssertNotNil(user)
            XCTAssertEqual(user?.email, email)
        } catch {
            XCTFail("L'inscription a échoué avec l'erreur : \(error.localizedDescription)")
        }
        
        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testGivenUserLogInInformation_WhenResetPassword_ThenResetPasswordSend() async throws {
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        
        let email = "test@example.com"
        
            try await auth.createUser(withEmail: email, password: "password")
            
            try await firebaseAuthService.resetPassword(email: email)

            // Cannot verify that the reset email has been sent because we are using an emulator.

        let user = auth.currentUser
        try? await user?.delete()
    }
    
    func testGivenUserLogedIn_WhenSignOutUser_ThenUserSignedOut() throws {
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)

            auth.signIn(withEmail: "test@example.com", password: "password")
            
            try firebaseAuthService.signOut()
            
            XCTAssertNil(auth.currentUser)

        let user = auth.currentUser
        user?.delete()
    }
    
    func testGivenUser_WhenDeletindUser_ThenUserDeleted() async throws {
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)

            try await auth.createUser(withEmail: "test@example.com", password: "password")

            try await auth.signIn(withEmail: "test@example.com", password: "password")
            
            try firebaseAuthService.deleteUser()
            
            try auth.signOut()
            
            XCTAssertNil(auth.currentUser)

        let user = auth.currentUser
        try? await user?.delete()
    }
    
//    func testGivenUserLogedIn_WhenGetCurrentUserEmail_ThenUserEmailRetreived() async throws {
//        let auth = Auth.auth()
//        auth.useEmulator(withHost: "localhost", port: 9099)
//
//        try await auth.createUser(withEmail: "test@example.com", password: "password")
//
//        try await auth.signIn(withEmail: "test@example.com", password: "password")
//
//        let email = firebaseAuthService.getCurrentUserEmail()
//
//        XCTAssertEqual(email, "test@example.com")
//
//        let user = auth.currentUser
//        try? await user?.delete()
//    }
    
    func testGivenUserLogedIn_WhenGetCurrentUserUID_ThenUserUIDRetreived() async throws {
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        
        try await auth.createUser(withEmail: "test@example.com", password: "password")

        try await auth.signIn(withEmail: "test@example.com", password: "password")
        
        let uid = firebaseAuthService.getCurrentUserUID()
        
        XCTAssertNotEqual(uid, "")
        
        let user = auth.currentUser
        try? await user?.delete()
    }
}
