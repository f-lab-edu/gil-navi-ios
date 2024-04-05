//
//  HomeViewController.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    private var homeView = HomeView()
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
}
