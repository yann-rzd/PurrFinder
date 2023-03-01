//
//  FirestoreServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 01/03/2023.
//

import XCTest
@testable import PurrFinder
import FirebaseFirestore

final class FirestoreServiceTests: XCTestCase {
    
    var firestoreService: FirestoreService!
    var db: Firestore!
    
    override func setUp() async throws{
        //        super.setUp()
        firestoreService = FirestoreService()
        db = Firestore.firestore()
    }
    
    //    func testSaveUserData() async throws {
    //        let user = PurrFinder.User(uid: "123", name: "John", email: "john@example.com", phone: "0606060606")
    //        try await firestoreService.saveUserData(user: user)
    //        let docRef = db.collection("users").document("123")
    //        let doc = try await docRef.getDocument()
    //        XCTAssertNotNil(doc.data())
    //    }
    
}
