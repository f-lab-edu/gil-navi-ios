//
//  PlaceSearchServiceTests.swift
//  GILTests
//
//  Created by 송우진 on 5/1/24.
//

import XCTest
import MapKit
@testable import GIL

final class PlaceSearchServiceTests: XCTestCase {
    var service: PlacesSearchService!

    override func setUp() {
        super.setUp()
        service = PlacesSearchService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }

    func test_주변장소검색() async throws {
        do {
            let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // 샌프란시스코
            let query = "cafe"
            let results = try await service.searchPlacesNearby(location: testLocation, query: query, regionRadius: 5000)
            XCTAssertFalse(results.isEmpty, "검색 결과가 비어 있으면 안 됩니다.")
        } catch {
            XCTFail("검색 중 실패해서는 안 됩니다: \(error)")
        }
    }
}
