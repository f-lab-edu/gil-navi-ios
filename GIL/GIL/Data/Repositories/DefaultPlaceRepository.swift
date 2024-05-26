//
//  DefaultPlaceRepository.swift
//  GIL
//
//  Created by 송우진 on 5/22/24.
//

import Foundation
import SwiftData

final class DefaultPlaceRepository {
    private var placeContainer: ModelContainer?

    init() {
        placeContainer = try? ModelContainer(for: Place.self)
    }
}

extension DefaultPlaceRepository: PlaceRepository {
    @MainActor
    func storePlace(_ mapItem: MapItem) {
        let data = Place(saveDate: Date(), mapItem: mapItem)
        placeContainer?.mainContext.insert(data)
    }

    @MainActor
    func fetchPlaces(
        limit: Int,
        order: SortOrder
    ) -> [Place] {
        let descriptor = FetchDescriptor<Place>(sortBy: [SortDescriptor(\.saveDate, order: order)])
        let places = (try? placeContainer?.mainContext.fetch(descriptor)) ?? []
        return Array(places.prefix(limit))
    }
}
