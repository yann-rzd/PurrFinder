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
        
        // Ajouter l'utilisateur dans la base de données avant de le supprimer
        let documentReference = FirestoreService.shared.getUserDocumentReference(user: user)
        try await FirestoreService.shared.saveUserData(user: user)
        
        // Vérifier que l'utilisateur existe avant la suppression
        let db = Firestore.firestore()
        let userRef = db.collection("userData").document(userUID)
        let snapshot = try await userRef.getDocument()
        XCTAssertTrue(snapshot.exists)
        
        // Supprimer l'utilisateur
        try await FirestoreService.shared.deleteUserData(uid: userUID)
        
        // Vérifier que l'utilisateur n'existe plus après la suppression
        let snapshotAfterDelete = try await userRef.getDocument()
        XCTAssertFalse(snapshotAfterDelete.exists)
    }

    func testGivenUserData_WhenUpdateUserNameAndPhoneData_ThenUserNameAndPhoneDataUpdated() async throws {
        // Create a test user and save their data
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
        
        // Update the user's name and phone number
        let newName = "Jane"
        let newPhone = "987-654-3210"
        try await FirestoreService.shared.updateUserDataNamePhone(userUID: userTest.uid, name: newName, phone: newPhone)
        
        // Get the user's data and check that their name and phone number were updated
        let updatedUserDTO = try await FirestoreService.shared.getUserData(userUID: userTest.uid)
        XCTAssertEqual(updatedUserDTO.name, newName)
        XCTAssertEqual(updatedUserDTO.phone, newPhone)
        
        // Delete the test user's data
        try await FirestoreService.shared.deleteUserData(uid: userTest.uid)
    }
    
    func testGivenUserData_WhenUpdateUserLocationData_ThenUserUserLocationDataUpdated() async throws {
        // Create a test user
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
        
        // Save the user to Firestore
        _ = FirestoreService.shared.getUserDocumentReference(user: user)
        
        try await FirestoreService.shared.saveUserData(user: user)
        
        // Update the user's location
        let newLatitude = "37.7749"
        let newLongitude = "-122.4194"
        try await FirestoreService.shared.updateUserLocationData(userUID: user.uid, latitude: newLatitude, longitude: newLongitude)
        
        // Get the updated user from Firestore
        let updatedUserDTO = try await FirestoreService.shared.getUserData(userUID: user.uid)
        
        // Check that the location was updated
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
        // Créer un document "postAlertData" dans la collection
        let db = Firestore.firestore()
        
        let postAlertDataRef = db.collection("postAlertData").addDocument(data: [
            "ownerUid": "12345",
            "alertMessage": "Test alert message"
        ])
        let postAlertDataId = postAlertDataRef.documentID
        
        // Appeler la fonction checkIfAlertInProgress avec l'UID de l'utilisateur
        let isAlertInProgress = await FirestoreService.shared.checkIfAlertInProgress(userUID: "12345")
        
        // Vérifier que la fonction renvoie true
        XCTAssertTrue(isAlertInProgress)
        
        // Supprimer le document créé précédemment
        try await db.collection("postAlertData").document(postAlertDataId).delete()
        
        // Appeler la fonction checkIfAlertInProgress avec un UID différent
        let isAlertInProgress2 = await FirestoreService.shared.checkIfAlertInProgress(userUID: "67890")
        
        // Vérifier que la fonction renvoie false
        XCTAssertFalse(isAlertInProgress2)
        
        try await db.collection("postAlertData").document(postAlertDataId).delete()
    }
    
    func testGivenPostAlertData_WhenDeletePostAlertData_ThenPostAlertDataDeleted() async throws {
        // Créer une alerte pour la supprimer ensuite
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
        
        // Vérifier que l'alerte a bien été créée
        let db = Firestore.firestore()
        let postAlertRef = db.collection("postAlertData").document(userUID)
        var snapshot = try await postAlertRef.getDocument()
        XCTAssertTrue(snapshot.exists)
        
        // Supprimer l'alerte
        try await FirestoreService.shared.deletePostAlert(userUID: userUID)
        
        // Vérifier que l'alerte a bien été supprimée
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



