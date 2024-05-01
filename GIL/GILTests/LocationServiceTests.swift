//
//  LocationServiceTests.swift
//  GILTests
//
//  Created by 송우진 on 5/1/24.
//

import XCTest
import CoreLocation
@testable import GIL

final class LocationServiceTests: XCTestCase {
    var locationService: LocationService!
    
    override func setUp() {
        super.setUp()
        locationService = LocationService()
    }

    override func tearDown() {
        locationService = nil
        super.tearDown()
    }
    
    func test_거리계산() {
        let currentLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // 샌프란시스코
        let targetLocation = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437) // 로스앤젤레스
        locationService.currentLocation = currentLocation
        
        let distance = locationService.distance(to: targetLocation)
        XCTAssertNotNil(distance, "거리 계산 결과가 nil이면 안 됩니다.")
    }
}
