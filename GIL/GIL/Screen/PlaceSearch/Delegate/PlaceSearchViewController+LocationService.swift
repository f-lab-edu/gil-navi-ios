//
//  PlaceSearchViewController+LocationService.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import Foundation

extension PlaceSearchViewController: LocationServiceDelegate {
    func didFetchAddress(_ address: String) {
        viewModel.locationService.stopUpdatingLocation()
        placeSearchView.navigationBar.addressLabel.text = address
    }
    
    func didFailWithError(_ error: Error) {
        Log.error("LocationService Error: \(error.localizedDescription)", error)
    }
}
