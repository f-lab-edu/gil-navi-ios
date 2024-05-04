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
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeViewController?
    
    func presentFetchedData(_ data: [PlaceData]) {
        let recentPlace = Array(data.prefix(min(3, data.count)))
        viewController?.displayFetchedData(recentPlace)
    }
    
    func presentSearchScreen() {
        viewController?.displaySearchScreen()
    }
}
