//
//  PlaceSearchViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit
import Combine
import SwiftData

final class PlaceSearchViewModel {
    private let placesSearchService = PlacesSearchService()
    private var placeContainer: ModelContainer?
    let locationService = LocationService()
    
    @Published var mapItems: [PlaceModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        placeContainer = try? ModelContainer(for: PlaceData.self)
    }
    
    func searchPlace(_ query: String) {
        guard let location = locationService.currentLocation else { return }
        Task {
            do {
                let mapItems = try await placesSearchService.searchPlacesNearby(location: location, query: query, regionRadius: 5000)
                await MainActor.run {
                    self.mapItems = mapItems
                        .map({ PlaceModel(mapItem: $0, distance: location.distance(to: $0.placemark.coordinate) ?? 0) })
                        .sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
                }
            } catch {
                Log.error(#function, error)
            }
        }
    }
    
    @MainActor 
    func storePlace(_ place: PlaceModel) {
        let data = PlaceData(saveDate: Date(), place: place)
        placeContainer?.mainContext.insert(data)
    }
    
    func getAddressForPlace(_ place: PlaceModel) -> String {
        guard let address = place.placemark.address else { return "" }
        if let formattedDistance = place.formattedDistance {
            return "\(formattedDistance) · \(address)"
        } else {
            return address
        }
    }
}
