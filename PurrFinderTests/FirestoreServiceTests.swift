//
//  FirestoreServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 09/03/2023.
//

import XCTest
@testable import PurrFinder
import Firebase
import FirebaseFirestore

final class FirestoreServiceTests: XCTestCase {
    struct TestUser {
        var uid: String = ""
        var name: String = ""
        var email: String = ""
        var phone: String = ""
        var profileImage: UIImage?
        var locationLatitude: String?
        var locationLongitude: String?
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let settings = FirestoreSettings()
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        let _ = Firestore.firestore()
    }
    
    override func tearDownWithError() throws {
        _ = Firestore.firestore()
        try super.tearDownWithError()
    }
    
    func testSaveUserData() async throws {
        let userTest = TestUser(
            uid: "1234",
            name: "John",
            email: "john@test.com",
            phone: "123-456-7890",
            profileImage: nil,
            locationLatitude: "37.7749",
            locationLongitude: "-122.4194"
        )
        
        let user = PurrFinder.User(uid: userTest.uid, name: userTest.name, email: userTest.email, phone: userTest.phone, profileImage: userTest.profileImage, locationLatitude: userTest.locationLatitude, locationLongitude: userTest.locationLongitude)
        
        let documentReference = FirestoreService.shared.getUserDocumentReference(user: user)
        try await FirestoreService.shared.saveUserData(user: user)
        
        let (_, userDTO) = try await documentReference.getDocument(as: UserDTO.self)
        
        XCTAssertEqual(userDTO.uid, user.uid)
        XCTAssertEqual(userDTO.name, user.name)
        XCTAssertEqual(userDTO.email, user.email)
        XCTAssertEqual(userDTO.phone, user.phone)
        XCTAssertNil(userDTO.profileImage)
        XCTAssertEqual(userDTO.locationLatitude, user.locationLatitude)
        XCTAssertEqual(userDTO.locationLongitude, user.locationLongitude)
    }
    
    func testGetUserData() async throws {
        let userTest = TestUser(
            uid: "1234",
            name: "John",
            email: "john@test.com",
            phone: "123-456-7890",
            profileImage: nil,
            locationLatitude: "37.7749",
            locationLongitude: "-122.4194"
        )

        let user = PurrFinder.User(uid: userTest.uid, name: userTest.name, email: userTest.email, phone: userTest.phone, profileImage: userTest.profileImage, locationLatitude: userTest.locationLatitude, locationLongitude: userTest.locationLongitude)
        
        // Save user data to Firestore
        let documentReference = FirestoreService.shared.getUserDocumentReference(user: user)
        try await FirestoreService.shared.saveUserData(user: user)
        
        // Retrieve user data from Firestore using getUserData
        let userDTO = try await FirestoreService.shared.getUserData(userUID: userTest.uid)
        
        // Assert that the retrieved data matches the test data
        XCTAssertEqual(userDTO.uid, user.uid)
        XCTAssertEqual(userDTO.name, user.name)
        XCTAssertEqual(userDTO.email, user.email)
        XCTAssertEqual(userDTO.phone, user.phone)
        XCTAssertNil(userDTO.profileImage)
        XCTAssertEqual(userDTO.locationLatitude, user.locationLatitude)
        XCTAssertEqual(userDTO.locationLongitude, user.locationLongitude)
    }
}

extension User {
    init(userTest: PurrFinderTests.User) {
        uid = userTest.uid
        name = userTest.name
        email = userTest.email
        phone = userTest.phone
        profileImage = userTest.profileImage
        locationLatitude = userTest.locationLatitude
        locationLongitude = userTest.locationLongitude
    }
}



