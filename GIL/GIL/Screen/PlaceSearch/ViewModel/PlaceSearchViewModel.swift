//
//  PlaceSearchViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import MapKit
import Combine
import SwiftData

final class PlaceSearchViewModel {
    private let placesSearchService = PlacesSearchService()
    private var placeContainer: ModelContainer?
    let locationService = LocationService()
    
    @Published var mapItems: [Place] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        locationService.requestLocation()
        placeContainer = try? ModelContainer(for: PlaceData.self)
    }
    
    func searchPlace(_ query: String) {
        guard let location = locationService.currentLocation else { return }
        Task {
            do {
                let mapItems = try await placesSearchService.searchPlacesNearby(location: location, query: query, regionRadius: 5000)
                await MainActor.run {
                    self.mapItems = mapItems
                        .map({ Place(mapItem: $0, distance: locationService.distance(to: $0.placemark.coordinate) ?? 0) })
                        .sorted(by: { $0.distance < $1.distance })
                }
            } catch {
                Log.error(#function, error)
            }
        }
    }
    
    @MainActor 
    func storePlace(_ place: Place) {
        let data = PlaceData(saveDate: Date(), place: place)
        placeContainer?.mainContext.insert(data)
    }
    
    func getAddressForPlace(_ place: Place) -> String {
        if place.distance > 0 {
            let formattedDistance = place.formattedDistanceString()
            return "\(formattedDistance) · \(place.address)"
        } else {
            return place.address
        }
    }
}
