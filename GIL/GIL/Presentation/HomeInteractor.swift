//
//  HomeInteractor.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//

import Foundation
import SwiftData

protocol HomeBusinessLogic {
    func performSearch()
    func fetchPlaceData()
    func navigateToRouteMap(with place: Place)
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    private var placeContainer: ModelContainer?
    
    init() {
        placeContainer = try? ModelContainer(for: Place.self)
    }
    
    @MainActor
    func fetchPlaceData() {
        let descriptor = FetchDescriptor<Place>(sortBy: [SortDescriptor(\.saveDate, order: .reverse)])
        let places = (try? placeContainer?.mainContext.fetch(descriptor)) ?? []
        let recentPlace = Array(places.prefix(min(3, places.count)))
        presenter?.presentFetchedData(recentPlace)
    }
    
    func performSearch() {
        presenter?.presentSearchScreen()
    }
    
    func navigateToRouteMap(with place: Place) {
        presenter?.presentRouteMap(place: place.mapItem)
    }
}
