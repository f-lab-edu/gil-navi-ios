//
//  HomeViewController.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit

final class HomeViewController: UIViewController {
    var presenter: HomePresentationLogic?
    private var homeView = HomeView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Binding
extension HomeViewController {
    func setupBindings() {
        bindButtons()
    }
    

    private func bindButtons() {
        let logoutAction = UIAction { _ in self.logoutButtonTapped()}
        homeView.logoutButton.addAction(logoutAction, for: .touchUpInside)
    }
    
}

// MARK: - Actions
extension HomeViewController {
    func logoutButtonTapped() {
        presenter?.handleLogoutRequest()
    }
}
