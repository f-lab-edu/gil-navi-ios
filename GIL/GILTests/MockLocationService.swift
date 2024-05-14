//
//  MockLocationService.swift
//  GILTests
//
//  Created by 송우진 on 5/2/24.
//

import CoreLocation
import XCTest
@testable import GIL

enum LocationError: Error {
    case failedToFetchLocation
}

class MockLocationServiceDelegate: LocationServiceDelegate {
    var lastFetchedAddress: String?
    var lastError: Error?
    var addressFetchExpectation: XCTestExpectation = XCTestExpectation()
    var errorExpectation: XCTestExpectation = XCTestExpectation()

    func didFetchAddress(_ address: String) {
        lastFetchedAddress = address
        addressFetchExpectation.fulfill()
    }

    func didFailWithError(_ error: Error) {
        lastError = error
        errorExpectation.fulfill()
    }
}

class MockLocationService: LocationService {
    func simulateLocationUpdate(location: CLLocation) {
        fetchAddress(for: location)
    }

    func simulateLocationFailure(error: Error) {
        delegate?.didFailWithError(error)
    }

    override func fetchAddress(for location: CLLocation) {
        let mockedAddress = "Mocked Address for \(location.coordinate.latitude), \(location.coordinate.longitude)"
        delegate?.didFetchAddress(mockedAddress)
    }
}

