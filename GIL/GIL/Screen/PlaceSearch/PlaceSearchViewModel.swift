//
//  PlaceSearchViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import MapKit
import Combine

class PlaceSearchViewModel {
    let locationService = LocationService()
    let placesSearchService = PlacesSearchService()
    
    @Published var mapItems: [Place] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        locationService.requestLocation()
    }
    
    func searchPlace(_ query: String) {
        guard let location = locationService.currentLocation else { return }
        Task {
            do {
                let mapItems = try await placesSearchService.searchPlacesNearby(location: location, query: query, regionRadius: 5000)
                await MainActor.run {
                    self.mapItems = mapItems
                        .map({ Place(from: $0, distance: locationService.distance(to: $0.placemark.coordinate)) })
                        .sorted(by: { $0.distance ?? 0.0 < $1.distance ?? 0.0 })
                }
            } catch {
                Log.error(#function, error)
            }
        }
    }
}
