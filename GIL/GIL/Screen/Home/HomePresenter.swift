//
//  HomePresenter.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//
import UIKit

protocol HomePresentationLogic {
    func presentSearchScreen()
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeViewController?
    
    func presentSearchScreen() {
        viewController?.displaySearchScreen()
    }
}
