//
//  PlaceSearchViewController.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit
import Combine

final class PlaceSearchViewController: BaseViewController, NavigationBarHideable {
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: PlaceSearchViewModel
    private var placeSearchCollectionViewHandler: PlaceSearchCollectionViewHandler?
    private let placeSearchView = PlaceSearchView()
    
    // MARK: - Initialization
    init(viewModel: PlaceSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        placeSearchCollectionViewHandler = PlaceSearchCollectionViewHandler(
            viewModel: viewModel,
            placeSearchView: placeSearchView,
            viewController: self
        )
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
        viewModel.locationService.requestLocation()
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

// MARK: - Error
extension PlaceSearchViewController {
    private func handleError(_ error: PlaceSearchError) {
        let message: String
        switch error {
        case .locationUnavailable: message = "위치 서비스를 사용할 수 없습니다. 위치 설정을 확인해 주세요."
        case .searchFailed: message = "장소를 찾지 못했습니다. 네트워크 연결을 확인하거나 다른 검색어를 시도해 보세요."
        }
        ToastManager.shared.showToast(message: message, position: .top)
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
        placeSearchView.navigationBar.backButton.addAction( UIAction { [weak self] _ in self?.backButtonTapped()}, for: .touchUpInside)
    }
    
    private func bindSearchBar() {
        placeSearchView.navigationBar.searchBar.delegate = self
    }
    
    private func bindLocationService() {
        viewModel.locationService.delegate = self
    }
    
    private func bindSearchMapItems() {
        viewModel.mapItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mapItems in
                self?.placeSearchCollectionViewHandler?.applySnapshot(with: mapItems)
            }
            .store(in: &cancellables)
    }
    
    private func bindErrors() {
        viewModel.errors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchBarDelegate
extension PlaceSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel.searchPlace(query)
        dismissKeyboard()
    }
}

// MARK: - LocationServiceDelegate
extension PlaceSearchViewController: LocationServiceDelegate {
    func didFetchPlacemark(_ placemark: Placemark) {
        viewModel.locationService.stopUpdatingLocation()
        placeSearchView.navigationBar.updateAddress(placemark.address ?? "")
    }
    
    func didFailWithError(_ error: Error) {
        viewModel.errors.send(.locationUnavailable)
    }
}
