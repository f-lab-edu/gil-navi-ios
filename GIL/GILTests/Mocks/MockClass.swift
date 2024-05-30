//
//  MockClass.swift
//  GILTests
//
//  Created by 송우진 on 5/15/24.
//

import XCTest
import MapKit
@testable import GIL

class MockLocationService: LocationServiceProtocol {
    var delegate: GIL.LocationServiceDelegate?

    var currentLocation: GIL.CLLocationModel?
    
    func requestLocation() {
        fatalError("Not implemented")
    }
    
    func stopUpdatingLocation() {
        fatalError("Not implemented")
    }
}

class MockPlacesSearchService: PlacesSearchServiceProtocol {
    var mapItems: [MKMapItem] = []
    
    func searchPlacesNearby(location: GIL.CLLocationModel, query: String, regionRadius: CLLocationDistance) async throws -> [MKMapItem] {
        return mapItems
    }
}
