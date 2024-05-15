//
//  PlaceSearchViewModelTests.swift
//  GILTests
//
//  Created by 송우진 on 5/15/24.
//

import XCTest
import MapKit
@testable import GIL

final class PlaceSearchViewModelTests: XCTestCase {
    var viewModel: PlaceSearchViewModel!
    var mockLocationService: MockLocationService!
    var mockPlacesSearchService: MockPlacesSearchService!
    
    override func setUp() {
        super.setUp()
        mockLocationService = MockLocationService()
        mockPlacesSearchService = MockPlacesSearchService()
        viewModel = PlaceSearchViewModel(locationService: mockLocationService, placesSearchService: mockPlacesSearchService)
    }
    
    func test_현재위치와검색어가주어졌을때_장소를검색하면_검색된장소목록이반환된다() async {
        // Given
        let testLocation = CLLocationModel(CLLocation(latitude: 37.7749, longitude: -122.4194))
        mockLocationService.currentLocation = testLocation
        
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
        let mapItem = MKMapItem(placemark: placemark)
        mockPlacesSearchService.mapItems = [mapItem]
        
        // When
        viewModel.searchPlace("test query")
        try! await Task.sleep(nanoseconds: 1 * 1_000_000_000)
        
        // Then
        XCTAssertEqual(viewModel.mapItems.first?.placemark.coordinate.latitude, testLocation.coordinate.latitude)
        XCTAssertEqual(viewModel.mapItems.first?.placemark.coordinate.longitude, testLocation.coordinate.longitude)
    }
}
