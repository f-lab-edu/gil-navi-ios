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
    func fetchPlaces()
    func navigateToRouteMap(with place: Place)
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    private var placeRepository: PlaceRepository
    
    init(placeRepository: PlaceRepository) {
        self.placeRepository = placeRepository
    }
    
    func fetchPlaces() {
        let recentPlaces = placeRepository.fetchPlaces(limit: 3, order: .reverse)
        presenter?.presentFetchedPlaces(recentPlaces)
    }
    
    func performSearch() {
        presenter?.presentSearchScreen()
    }
    
    func navigateToRouteMap(with place: Place) {
        presenter?.presentRouteMap(place: place.mapItem)
    }
}
