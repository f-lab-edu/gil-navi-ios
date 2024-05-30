//
//  HomePresenter.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//
import UIKit

protocol HomePresentationLogic {
    func presentSearchScreen()
    func presentFetchedPlaces(_ data: [Place])
    func presentRouteMap(place: MapItem)
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeViewController?
    
    func presentFetchedPlaces(_ data: [Place]) {
        viewController?.displayFetchedPlaces(data)
    }
    
    func presentSearchScreen() {
        viewController?.displaySearchScreen()
    }
    
    func presentRouteMap(place: MapItem) {
        viewController?.displayRouteMap(place: place)
    }
}
