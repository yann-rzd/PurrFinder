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
    
    func testDownloadProfileImage() async throws {
        // 1. Créer une image factice pour tester.
        let image = UIImage(systemName: "photo")!
        
        // 2. Enregistrer l'image factice dans Firebase Storage.
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistProfileImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        // 3. Télécharger l'image depuis Firebase Storage.
        let downloadedImage = try await storageService.downloadProfileImage(userUID: userUID)
        
        // 4. Vérifier que l'image téléchargée est identique à l'image factice.
        XCTAssertNotNil(downloadedImage)
        
        // 5. Supprimer l'image enregistrée de Firebase Storage.
        let ref = Storage.storage().reference(withPath: "profileImages/\(userUID)")
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
        }
    }
    
    func testDownloadAnimalImage() async throws {
        // 1. Créer une image factice pour tester.
        let image = UIImage(systemName: "photo")!
        
        // 2. Enregistrer l'image factice dans Firebase Storage.
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistAnimalImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        // 3. Télécharger l'image depuis Firebase Storage.
        let downloadedImage = try await storageService.downloadAnimalImage(userUID: userUID)
        
        // 4. Vérifier que l'image téléchargée est identique à l'image factice.
        XCTAssertNotNil(downloadedImage)
        
        // 5. Supprimer l'image enregistrée de Firebase Storage.
        let ref = Storage.storage().reference(withPath: "animalImages/\(userUID)")
        ref.delete { error in
            if let error = error {
                print("Failed to delete file: \(error)")
            }
        }
    }
    
    func testDeleteProfileImage() async throws {
        // 1. Créer une image factice pour tester.
        let image = UIImage(systemName: "photo")!
        
        // 2. Enregistrer l'image factice dans Firebase Storage.
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistProfileImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        // 3. Vérifier que la référence de l'image existe dans Firebase Storage.
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
        
        // 4. Supprimer l'image depuis Firebase Storage.
        try await storageService.deleteUserProfileImageFromStorage(userUID: userUID)
        sleep(2)
        
        // 5. Vérifier que la référence de l'image n'existe plus dans Firebase Storage.
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
    
    func testDeleteAnimalImage() async throws {
        // 1. Créer une image factice pour tester.
        let image = UIImage(systemName: "photo")!
        
        // 2. Enregistrer l'image factice dans Firebase Storage.
        let userUID = "testUser"
        let storageService = StorageService()
        storageService.persistAnimalImageToStorage(userUID: userUID, image: image)
        sleep(2)
        
        // 3. Vérifier que la référence de l'image existe dans Firebase Storage.
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
        
        // 4. Supprimer l'image depuis Firebase Storage.
        try await storageService.deleteAnimalImageFromStorage(userUID: userUID)
        sleep(2)
        
        // 5. Vérifier que la référence de l'image n'existe plus dans Firebase Storage.
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
