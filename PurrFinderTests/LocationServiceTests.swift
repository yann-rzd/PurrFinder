//
//  LocationServiceTests.swift
//  PurrFinderTests
//
//  Created by Yann Rouzaud on 01/03/2023.
//

import XCTest
@testable import PurrFinder
import CoreLocation

class LocationServiceTests: XCTestCase {
    
    
    var locationManager: FakeCLLocationManager!
    var delegate: FakeLocationServiceDelegate!
    var locationService: LocationService!
    
    override func setUp() {
        super.setUp()
        locationManager = FakeCLLocationManager()
        delegate = FakeLocationServiceDelegate()
        locationService = LocationService()
        locationService.delegate = delegate
        locationService.locationManager = locationManager
    }
    
    override func tearDown() {
        locationManager = nil
        delegate = nil
        locationService = nil
        super.tearDown()
    }
    
    func testGivenLocationNotUpdated_WhenStartUpdatingLocation_ThenLocationUpdated() {
        locationService.startUpdatingLocation()
        XCTAssertTrue(locationManager.delegate === locationService)
        XCTAssertTrue(locationManager.requestWhenInUseAuthorizationCalled)
        XCTAssertTrue(locationManager.startUpdatingLocationCalled)
    }
    
    func testGivenLocationUpdated_WhenStopUpdatingLocation_ThenLocationNotUpdated() {
        locationService.stopUpdatingLocation()
        XCTAssertTrue(locationManager.stopUpdatingLocationCalled)
    }
    
    
    func testGivenLocation_WhenNewLocation_ThenLocationUpdated() {
        let location = CLLocation(latitude: 37.33233141, longitude: -122.0312186)
        let locations = [location]
        locationService.locationManager(locationManager, didUpdateLocations: locations)
        XCTAssertTrue(delegate.locationServiceDidUpdateLocationCalled)
        XCTAssertEqual(delegate.latitude, location.coordinate.latitude)
        XCTAssertEqual(delegate.longitude, location.coordinate.longitude)
    }
}

class FakeCLLocationManager: CLLocationManager {
    var requestWhenInUseAuthorizationCalled = false
    var startUpdatingLocationCalled = false
    var stopUpdatingLocationCalled = false
    
    override func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCalled = true
    }
    
    override func startUpdatingLocation() {
        startUpdatingLocationCalled = true
    }
    
    override func stopUpdatingLocation() {
        stopUpdatingLocationCalled = true
    }
}

class FakeLocationServiceDelegate: LocationServiceDelegate {
    var locationServiceDidUpdateLocationCalled = false
    var latitude: Double?
    var longitude: Double?
    
    func locationServiceDidUpdateLocation(_ locationService: LocationService, latitude: Double, longitude: Double) {
        locationServiceDidUpdateLocationCalled = true
        self.latitude = latitude
        self.longitude = longitude
    }
}
