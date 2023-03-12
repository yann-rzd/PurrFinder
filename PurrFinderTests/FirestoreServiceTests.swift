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
    
    struct TestPostAlert {
        var uid: String = ""
        var animalName: String = ""
        var animalType: String = ""
        var animalBreed: String = ""
        var animalDescription: String = ""
        var postDate: String = ""
        var ownerUid: String = ""
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
    
    func testGivenUserData_WhenSaveUserData_ThenUserDataSaved() async throws {
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
    
    func testGivenUserData_WhenGetUserData_ThenUserDataRetreived() async throws {
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
        
        _ = FirestoreService.shared.getUserDocumentReference(user: user)
        try await FirestoreService.shared.saveUserData(user: user)
        
        let userDTO = try await FirestoreService.shared.getUserData(userUID: userTest.uid)
        
        XCTAssertEqual(userDTO.uid, user.uid)
        XCTAssertEqual(userDTO.name, user.name)
        XCTAssertEqual(userDTO.email, user.email)
        XCTAssertEqual(userDTO.phone, user.phone)
        XCTAssertNil(userDTO.profileImage)
        XCTAssertEqual(userDTO.locationLatitude, user.locationLatitude)
        XCTAssertEqual(userDTO.locationLongitude, user.locationLongitude)
    }
    
    func testGivenUserData_WhenDeletingUserData_ThenUserDataDeleted() async throws {
        let userUID = "1234"
        let userTest = TestUser(
            uid: userUID,
            name: "John",
            email: "john@test.com",
            phone: "123-456-7890",
            profileImage: nil,
            locationLatitude: "37.7749",
            locationLongitude: "-122.4194"
        )
        
        let user = PurrFinder.User(uid: userTest.uid, name: userTest.name, email: userTest.email, phone: userTest.phone, profileImage: userTest.profileImage, locationLatitude: userTest.locationLatitude, locationLongitude: userTest.locationLongitude)
        
        // Add the user to the database before deleting it
        _ = FirestoreService.shared.getUserDocumentReference(user: user)
        try await FirestoreService.shared.saveUserData(user: user)
        
        // Verify that the user exists before deleting
        let db = Firestore.firestore()
        let userRef = db.collection("userData").document(userUID)
        let snapshot = try await userRef.getDocument()
        XCTAssertTrue(snapshot.exists)
        
        // Delete the user
        try await FirestoreService.shared.deleteUserData(uid: userUID)
        
        // Check that the user no longer exists after deletion
        let snapshotAfterDelete = try await userRef.getDocument()
        XCTAssertFalse(snapshotAfterDelete.exists)
    }

    func testGivenUserData_WhenUpdateUserNameAndPhoneData_ThenUserNameAndPhoneDataUpdated() async throws {
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
        
        try await FirestoreService.shared.saveUserData(user: user)
        
        let newName = "Jane"
        let newPhone = "987-654-3210"
        try await FirestoreService.shared.updateUserDataNamePhone(userUID: userTest.uid, name: newName, phone: newPhone)
        
        let updatedUserDTO = try await FirestoreService.shared.getUserData(userUID: userTest.uid)
        XCTAssertEqual(updatedUserDTO.name, newName)
        XCTAssertEqual(updatedUserDTO.phone, newPhone)
        
        try await FirestoreService.shared.deleteUserData(uid: userTest.uid)
    }
    
    func testGivenUserData_WhenUpdateUserLocationData_ThenUserUserLocationDataUpdated() async throws {
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
        
        _ = FirestoreService.shared.getUserDocumentReference(user: user)
        
        try await FirestoreService.shared.saveUserData(user: user)
        
        let newLatitude = "37.7749"
        let newLongitude = "-122.4194"
        try await FirestoreService.shared.updateUserLocationData(userUID: user.uid, latitude: newLatitude, longitude: newLongitude)
        
        let updatedUserDTO = try await FirestoreService.shared.getUserData(userUID: user.uid)
        
        XCTAssertEqual(updatedUserDTO.locationLatitude, newLatitude)
        XCTAssertEqual(updatedUserDTO.locationLongitude, newLongitude)
    }
    
    func testGivenPostAlertData_WhenSavePostAlertData_ThenPostAlertDataSaved() async throws {
        let postAlertTest = TestPostAlert(
            uid: "1234",
            animalName: "Simba",
            animalType: "Cat",
            animalBreed: "Siamese",
            animalDescription: "This is Simba. He is a 5-year-old Siamese cat with blue eyes.",
            postDate: "2022-03-09T16:00:00Z",
            ownerUid: "5678"
        )
        
        let postAlert = PurrFinder.PostAlert(
            uid: postAlertTest.uid,
            animalName: postAlertTest.animalName,
            animalType: postAlertTest.animalType,
            animalBreed: postAlertTest.animalBreed,
            animalDescription: postAlertTest.animalDescription,
            postDate: postAlertTest.postDate,
            ownerUid: postAlertTest.ownerUid
        )
        
        let userUID = "5678"
        try await FirestoreService.shared.createPostAlert(post: postAlert, userUID: userUID)
        
        let db = Firestore.firestore()
        let postAlertRef = db.collection("postAlertData").document(userUID)
        let snapshot = try await postAlertRef.getDocument()
        XCTAssertTrue(snapshot.exists)
        
        let postAlertDTO = try await FirestoreService.shared.getPostAlertData(userUID: userUID)
        
        XCTAssertEqual(postAlertDTO.uid, postAlertTest.uid)
        XCTAssertEqual(postAlertDTO.animalName, postAlertTest.animalName)
        XCTAssertEqual(postAlertDTO.animalType, postAlertTest.animalType)
        XCTAssertEqual(postAlertDTO.animalBreed, postAlertTest.animalBreed)
        XCTAssertEqual(postAlertDTO.animalDescription, postAlertTest.animalDescription)
        XCTAssertEqual(postAlertDTO.postDate, postAlertTest.postDate)
        XCTAssertEqual(postAlertDTO.ownerUid, postAlertTest.ownerUid)
    }
    
    func testGivenPostAlertData_WhenCheckIfAlertInProgress_ThenReturnIfAlertInProgress() async throws {
        let db = Firestore.firestore()
        
        let postAlertDataRef = db.collection("postAlertData").addDocument(data: [
            "ownerUid": "12345",
            "alertMessage": "Test alert message"
        ])
        let postAlertDataId = postAlertDataRef.documentID
        
        let isAlertInProgress = await FirestoreService.shared.checkIfAlertInProgress(userUID: "12345")
        
        XCTAssertTrue(isAlertInProgress)
        
        try await db.collection("postAlertData").document(postAlertDataId).delete()
        
        let isAlertInProgress2 = await FirestoreService.shared.checkIfAlertInProgress(userUID: "67890")
        
        XCTAssertFalse(isAlertInProgress2)
        
        try await db.collection("postAlertData").document(postAlertDataId).delete()
    }
    
    func testGivenPostAlertData_WhenDeletePostAlertData_ThenPostAlertDataDeleted() async throws {
        let postAlertTest = TestPostAlert(
            uid: "1234",
            animalName: "Simba",
            animalType: "Cat",
            animalBreed: "Siamese",
            animalDescription: "This is Simba. He is a 5-year-old Siamese cat with blue eyes.",
            postDate: "2022-03-09T16:00:00Z",
            ownerUid: "5678"
        )
        
        let postAlert = PurrFinder.PostAlert(
            uid: postAlertTest.uid,
            animalName: postAlertTest.animalName,
            animalType: postAlertTest.animalType,
            animalBreed: postAlertTest.animalBreed,
            animalDescription: postAlertTest.animalDescription,
            postDate: postAlertTest.postDate,
            ownerUid: postAlertTest.ownerUid
        )
        
        let userUID = "5678"
        try await FirestoreService.shared.createPostAlert(post: postAlert, userUID: userUID)
        
        let db = Firestore.firestore()
        let postAlertRef = db.collection("postAlertData").document(userUID)
        var snapshot = try await postAlertRef.getDocument()
        XCTAssertTrue(snapshot.exists)
        
        try await FirestoreService.shared.deletePostAlert(userUID: userUID)
        
        snapshot = try await postAlertRef.getDocument()
        XCTAssertFalse(snapshot.exists)
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

extension PostAlert {
    init(postAlertTest: PurrFinder.PostAlert) {
        uid = postAlertTest.uid
        animalName = postAlertTest.animalName
        animalType = postAlertTest.animalType
        animalBreed = postAlertTest.animalBreed
        animalDescription = postAlertTest.animalDescription
        postDate = postAlertTest.postDate
        ownerUid = postAlertTest.ownerUid
    }
}



