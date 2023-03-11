//
//  StorageServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 11/03/2023.
//

import XCTest
@testable import PurrFinder
import Firebase
import FirebaseStorage
import FirebaseAuth

final class StorageServiceTests: XCTestCase {
    
    var storageService: StorageService!
    var firebaseAuthService: FirebaseAuthService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        storageService = StorageService()
        firebaseAuthService = FirebaseAuthService() 
    }
    
    func testPersistProfileImageToStorage() async throws {
        // Create a test image to be stored in Firebase Storage
        let image = UIImage(systemName: "photo")!
        
        // Create a test user on the Firebase Auth emulator
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        let email = "testuser@test.com"
        let password = "password"
        try await auth.createUser(withEmail: email, password: password)
        
        // Call the function to persist the image to Firebase Storage
        let storage = Storage.storage()
        storage.useEmulator(withHost: "localhost", port: 9199)
        storageService.persistProfileImageToStorage(image: image)
        sleep(2)
        
        // Get the download URL for the stored image
        let userUID = auth.currentUser?.uid ?? ""
        print("🔥🔥🔥🔥🔥🔥🔥🔥 USER ID : \(userUID)")
        let ref = storage.reference(withPath: "profileImages/\(userUID)")
        let url = try await ref.downloadURL()
        
        // Verify that the download URL is valid
        XCTAssertNotNil(url)
        XCTAssertNotEqual(url.absoluteString, "")
        
        // Clean up after the test by deleting the stored image and the test user
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
            
            auth.currentUser?.delete { error in
                if let error = error {
                    print("Failed to delete test user: \(error)")
                }
            }
        }
    }
}
