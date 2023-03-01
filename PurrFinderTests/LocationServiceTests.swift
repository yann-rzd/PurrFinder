//
//  LocationServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 01/03/2023.
//

import XCTest
@testable import PurrFinder
import CoreLocation

final class LocationServiceTests: XCTestCase {
    var locationService: LocationService!
    var mockLocationManager: MockCLLocationManager!
    
    override func setUp() {
        super.setUp()
        locationService = LocationService()
        mockLocationManager = MockCLLocationManager()
    }
    
    override func tearDown() {
        locationService = nil
        mockLocationManager = nil
        super.tearDown()
    }
    
    func testLocationManagerDidUpdateLocations() {
        let locationManager = CLLocationManager()
        let mockLocation = CLLocation(latitude: 37.3317, longitude: -122.0307)
        locationService.locationManager(locationManager, didUpdateLocations: [mockLocation])
        XCTAssertEqual(locationService.latitude, mockLocation.coordinate.latitude)
        XCTAssertEqual(locationService.longitude, mockLocation.coordinate.longitude)
    }
    
    func testLocationManagerDidChangeAuthorization_authorizedWhenInUse() {
        mockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
        locationService.locationManagerDidChangeAuthorization(mockLocationManager)
        XCTAssertTrue(locationService.isUpdatingLocation)
    }

    func testLocationManagerDidChangeAuthorization_notAuthorized() {
        mockLocationManager.mockAuthorizationStatus = .denied
        locationService.locationManagerDidChangeAuthorization(mockLocationManager)
        XCTAssertFalse(locationService.isUpdatingLocation)
    }
}

class MockCLLocationManager: CLLocationManager {
    
    var mockAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override var authorizationStatus: CLAuthorizationStatus {
        return mockAuthorizationStatus
    }
}
