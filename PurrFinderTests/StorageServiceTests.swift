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
    
    override class func setUp() {
        super.setUp()
        Storage.storage().useEmulator(withHost: "localhost", port: 9199)
    }

    func testGivenProfileImage_WhenPersistProfileImage_ThenProfileImagePersisted() async throws {
        let image = UIImage(systemName: "photo")!
        
        let userUID = "7890"
        
        let storageService = StorageService()
        storageService.persistProfileImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        let ref = Storage.storage().reference(withPath: "profileImages/\(userUID)")
        let url = try await ref.downloadURL()
        
        XCTAssertNotNil(url)
        XCTAssertNotEqual(url.absoluteString, "")
        
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
        }
    }
    
    func testGivenAnimalImage_WhenPersistAnimalImage_ThenAnimalImagePersisted() async throws {
        let image = UIImage(systemName: "photo")!
        
        let userUID = "7890"
        
        let storageService = StorageService()
        storageService.persistAnimalImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        let ref = Storage.storage().reference(withPath: "animalImages/\(userUID)")
        let url = try await ref.downloadURL()
        
        XCTAssertNotNil(url)
        XCTAssertNotEqual(url.absoluteString, "")
        
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
        }
    }
    
    func testGivenProfileImage_WhenDownloadProfileImage_ThenProfileImageDownloaded() async throws {
        let image = UIImage(systemName: "photo")!
        
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistProfileImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        let downloadedImage = try await storageService.downloadProfileImage(userUID: userUID)
        
        XCTAssertNotNil(downloadedImage)
        
        let ref = Storage.storage().reference(withPath: "profileImages/\(userUID)")
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
        }
    }
    
    func testGivenAnimalImage_WhenDownloadAnimalImage_ThenAnimalImageDownloaded() async throws {
        let image = UIImage(systemName: "photo")!
        
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistAnimalImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        let downloadedImage = try await storageService.downloadAnimalImage(userUID: userUID)
        
        XCTAssertNotNil(downloadedImage)
        
        let ref = Storage.storage().reference(withPath: "animalImages/\(userUID)")
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
        }
    }
    
    func testGivenProfileImage_WhenDeleteProfileImage_ThenProfileImageDeleted() async throws {
        // Create a test image to test.
        let image = UIImage(systemName: "photo")!
        
        // Save the test image in Firebase Storage
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistProfileImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        // Verify that the image reference exists in Firebase Storage
        let ref = Storage.storage().reference(withPath: "profileImages/\(userUID)")
        var isRefExists = false
        let listResult = try await ref.parent()!.listAll()
        for item in listResult.items {
            if item.name == ref.name {
                isRefExists = true
                break
            }
        }
        XCTAssertTrue(isRefExists, "The reference should exist in Firebase Storage.")
        
        // Delete the image from Firebase Storage
        try await storageService.deleteUserProfileImageFromStorage(userUID: userUID)
        sleep(2)
        
        // Check that the image reference no longer exists in Firebase Storage
        isRefExists = false
        let newListResult = try await ref.parent()!.listAll()
        for item in newListResult.items {
            if item.name == ref.name {
                isRefExists = true
                break
            }
        }
        XCTAssertFalse(isRefExists, "The reference should not exist in Firebase Storage.")
    }
    
    func testGivenAniamlImage_WhenDeleteAnimalImage_ThenAnimalImageDeleted() async throws {
        let image = UIImage(systemName: "photo")!
        
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistAnimalImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        let ref = Storage.storage().reference(withPath: "animalImages/\(userUID)")
        var isRefExists = false
        let listResult = try await ref.parent()!.listAll()
        for item in listResult.items {
            if item.name == ref.name {
                isRefExists = true
                break
            }
        }
        XCTAssertTrue(isRefExists, "The reference should exist in Firebase Storage.")
        
        try await storageService.deleteAnimalImageFromStorage(userUID: userUID)
        sleep(2)

        isRefExists = false
        let newListResult = try await ref.parent()!.listAll()
        for item in newListResult.items {
            if item.name == ref.name {
                isRefExists = true
                break
            }
        }
        XCTAssertFalse(isRefExists, "The reference should not exist in Firebase Storage.")
    }
}
