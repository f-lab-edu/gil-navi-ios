//
//  PlaceSearchViewController.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit
import CoreLocation
import MapKit

final class PlaceSearchViewController: BaseViewController, NavigationBarHideable {
    private var viewModel: PlaceSearchViewModel
    private var placeSearchView = PlaceSearchView()
    private var placeSearchCollectionViewHandler: PlaceSearchCollectionViewHandler?
    
    // MARK: - Initialization
    init(viewModel: PlaceSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        placeSearchCollectionViewHandler = PlaceSearchCollectionViewHandler(viewModel: viewModel, placeSearchView: placeSearchView)
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
        setupBindings()
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
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup Binding
extension PlaceSearchViewController {
    private func setupBindings() {
        bindButtons()
        bindSearchBar()
        bindLocationService()
        bindSearchMapItems()
    }
    
    private func bindButtons() {
        placeSearchView.navigationBar.backButton.addAction( UIAction { _ in self.backButtonTapped()}, for: .touchUpInside)
    }
    
    private func bindSearchBar() {
        placeSearchView.navigationBar.searchBar.delegate = self
    }
    
    private func bindLocationService() {
        viewModel.locationService.delegate = self
    }
    
    private func bindSearchMapItems() {
        viewModel.$mapItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mapItems in
                guard let self else { return }
                self.placeSearchCollectionViewHandler?.applySnapshot(with: mapItems)
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - UISearchBarDelegate
extension PlaceSearchViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        viewModel.searchPlace(searchText)
    }
}

// MARK: - LocationServiceDelegate
extension PlaceSearchViewController: LocationServiceDelegate {
    func didFetchAddress(_ address: String) {
        viewModel.locationService.stopUpdatingLocation()
        placeSearchView.navigationBar.addressLabel.text = address
    }
    
    func didFailWithError(_ error: Error) {
        Log.error("LocationService Error: \(error.localizedDescription)", error)
    }
}
