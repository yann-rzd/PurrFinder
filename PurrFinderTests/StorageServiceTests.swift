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
    
    func testPersistProfileImageToStorage() async throws {
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
    
    func testPersistAnimalImageToStorage() async throws {
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
}
