//
//  PlaceSearchViewController.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit

final class PlaceSearchViewController: BaseViewController, NavigationBarHideable {
    private var viewModel: PlaceSearchViewModel
    var placeSearchView = PlaceSearchView()
    
    // MARK: - Initialization
    init(viewModel: PlaceSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = placeSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
    }
}

// MARK: - Actions
extension PlaceSearchViewController {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup
extension PlaceSearchViewController {
    func setup() {
        setupBindings()
        setupLocationService()
    }
    
    private func setupBindings() {
        bindButtons()
    }
    
    private func setupLocationService() {
        viewModel.locationService.delegate = self
        viewModel.locationService.requestLocation()
    }
    
    private func bindButtons() {
        let backAction = UIAction { _ in self.backButtonTapped() }
        placeSearchView.navigationBar.backButton.addAction(backAction, for: .touchUpInside)
    }
}

// MARK: - LocationServiceDelegate
extension PlaceSearchViewController: LocationServiceDelegate {
    func didFailWithError(_ error: Error) {
        Log.error("LocationService Error: \(error.localizedDescription)", error)
    }
    
    func didFetchAddress(_ address: String) {
        viewModel.locationService.stopUpdatingLocation()
        placeSearchView.navigationBar.addressLabel.text = address
    }
}
