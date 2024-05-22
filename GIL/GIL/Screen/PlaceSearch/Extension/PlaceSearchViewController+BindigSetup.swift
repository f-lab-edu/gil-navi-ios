//
//  PlaceSearchViewController+BindigSetup.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

extension PlaceSearchViewController {
    func setupBindings() {
        bindButtons()
        bindSearchBar()
        bindCollectionView()
        bindLocationService()
        bindSearchMapItems()
    }
    
    private func bindButtons() {
        let backAction = UIAction { _ in self.backButtonTapped() }
        placeSearchView.navigationBar.backButton.addAction(backAction, for: .touchUpInside)
    }
    
    private func bindSearchBar() {
        placeSearchView.navigationBar.searchBar.delegate = self
    }
    
    private func bindCollectionView() {
        placeSearchView.searchResultsCollectionView.delegate = self
    }
    
    private func bindLocationService() {
        viewModel.locationService.delegate = self
    }
    
    private func bindSearchMapItems() {
        viewModel.$mapItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mapItems in
                guard let self else { return }
                self.applySnapshot(with: mapItems)
            }
            .store(in: &viewModel.cancellables)
    }
}
