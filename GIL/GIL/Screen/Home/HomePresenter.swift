//
//  HomePresenter.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//
import UIKit

protocol HomePresentationLogic {
    func handleLogoutRequest()
}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeViewController?
    var interactor: HomeBusinessLogic?

    func handleLogoutRequest() {
        interactor?.signOut()
    }
}
