//
//  LocationServiceTests.swift
//  GILTests
//
//  Created by 송우진 on 5/1/24.
//

import XCTest
import CoreLocation
@testable import GIL

class LocationServiceTests: XCTestCase {
    var locationService: MockLocationService!
    var mockDelegate: MockLocationServiceDelegate!
    let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // 샌프란시스코
    
    override func setUp() {
        super.setUp()
        locationService = MockLocationService()
        mockDelegate = MockLocationServiceDelegate()
        locationService.delegate = mockDelegate
    }
    
    override func tearDown() {
        locationService = nil
        mockDelegate = nil
        super.tearDown()
    }

    func test_위치업데이트성공() {
        locationService.simulateLocationUpdate(location: testLocation)
        
        wait(for: [mockDelegate.addressFetchExpectation], timeout: 1.0)
        XCTAssertEqual(mockDelegate.lastFetchedAddress, "Mocked Address for 37.7749, -122.4194")
    }

    func test_위치업데이트실패() {
        locationService.simulateLocationFailure(error: LocationError.failedToFetchLocation)
        
        wait(for: [mockDelegate.errorExpectation], timeout: 1.0)
        
        XCTAssertNotNil(mockDelegate.lastError)
        XCTAssertEqual(mockDelegate.lastError as? LocationError, .failedToFetchLocation)
    }
    

    func test_거리계산() {
        let targetLocation = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437) // 로스앤젤레스
        locationService.currentLocation = testLocation
        
        let distance = locationService.distance(to: targetLocation)
        XCTAssertNotNil(distance, "거리 계산 결과가 nil이면 안 됩니다.")
        
        let distanceInKilometers = distance! / 1000
        XCTAssertEqual(distanceInKilometers, 559, accuracy: 10.0, "거리는 559킬로미터에 가까워야 합니다.")
    }
}
