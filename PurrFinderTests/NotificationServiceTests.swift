//
//  NotificationServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 11/03/2023.
//

import XCTest
@testable import PurrFinder
import UserNotifications
import CoreLocation

final class NotificationServiceTests: XCTestCase {

    let notificationService = NotificationService.shared

        func testGivenNotification_WhenRequestNotificationAuthorization_ThenAuthorizationrequested() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                XCTAssertNotNil(granted)
                XCTAssertNil(error)
            }
        }
        
        func testGivenNotification_WhenCheckForPermissionNotification_ThenPermissionChecked() {
            let ownerLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            let animalImage = UIImage(imageLiteralResourceName: "Cat")
            let animalName = "Fluffy"
            let animalType = "Cat"
            let animalBreed = "Persian"
            let animalDescription = "Fluffy is a friendly cat who loves to cuddle."
            let ownerName = "John Doe"
            let ownerPhone = "555-1234"
            
            notificationService.checkForPermission(ownerLocation: ownerLocation,
                                                    animalImage: animalImage,
                                                    animalName: animalName,
                                                    animalType: animalType,
                                                    animalBreed: animalBreed,
                                                    animalDescription: animalDescription,
                                                    ownerName: ownerName,
                                                    ownerPhone: ownerPhone)
            
            let expectation = XCTestExpectation(description: "Wait for notification to be scheduled")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 10)
        }
        
        func testGivenLocation_WhenGetRegionOfNotification_ThenRegionRetreive() {
            let location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            let region = notificationService.getRegion(from: location)
            XCTAssertNotNil(region)
            XCTAssertEqual(region.center.latitude, location.latitude)
            XCTAssertEqual(region.center.longitude, location.longitude)
            XCTAssertEqual(region.radius, 10)
            XCTAssertEqual(region.identifier, "PetLocation")
            XCTAssertTrue(region.notifyOnEntry)
            XCTAssertFalse(region.notifyOnExit)
        }

}
