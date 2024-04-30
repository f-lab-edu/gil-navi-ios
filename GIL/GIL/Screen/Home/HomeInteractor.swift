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
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    private var placeContainer: ModelContainer?

    init() {
        placeContainer = try? ModelContainer(for: PlaceData.self)
    }
    
    @MainActor
    func fetchPlaceData() {
        let descriptor = FetchDescriptor<PlaceData>(sortBy: [SortDescriptor(\.saveDate)])
        let places = (try? placeContainer?.mainContext.fetch(descriptor)) ?? []
        presenter?.presentFetchedData(places)
    }
    
    func performSearch() {
        presenter?.presentSearchScreen()
    }
}
