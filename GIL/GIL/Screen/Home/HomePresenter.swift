//
//  HomePresenter.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//
import UIKit

protocol HomePresentationLogic {
    func presentSearchScreen()
    func presentFetchedData(_ data: [PlaceData])
    func presentRouteMap(place: PlaceModel)
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeViewController?
    
    func presentFetchedData(_ data: [PlaceData]) {
        viewController?.displayFetchedData(data)
    }
    
    func presentSearchScreen() {
        viewController?.displaySearchScreen()
    }
    
    func presentRouteMap(place: PlaceModel) {
        viewController?.displayRouteMap(place: place)
    }
}
