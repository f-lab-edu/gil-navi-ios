//
//  PlaceRepository.swift
//  GIL
//
//  Created by 송우진 on 5/22/24.
//

import Foundation
import SwiftData

protocol PlaceRepository {
    func storePlace(_ mapItem: MapItem)
    
    func fetchPlaces() -> [Place]
    func updatePlace(_ place: Place)
    func deletePlace(_ place: Place)
}

final class DefaultPlaceRepository: PlaceRepository {
    private var placeContainer: ModelContainer?

    init() {
        placeContainer = try? ModelContainer(for: Place.self)
    }

    @MainActor 
    func storePlace(_ mapItem: MapItem) {
        let data = Place(saveDate: Date(), mapItem: mapItem)
        placeContainer?.mainContext.insert(data)
    }

    func fetchPlaces() -> [Place] {
        return []
    }

    func updatePlace(_ place: Place) {
    }

    func deletePlace(_ place: Place) {
    }
}
