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
    enum Section: CaseIterable {
        case main
    }
    
    private var viewModel: PlaceSearchViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Place>!
    private var placeSearchView = PlaceSearchView()
    
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
        setupBindings()
        setupLocationService()
        setupCollectionView()
        configureDataSource()
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

// MARK: - Binding
extension PlaceSearchViewController {
    private func setupBindings() {
        bindButtons()
        bindSearchBar()
        bindSearchMapItems()
    }
    
    private func bindButtons() {
        let backAction = UIAction { _ in self.backButtonTapped() }
        placeSearchView.navigationBar.backButton.addAction(backAction, for: .touchUpInside)
    }
    
    private func bindSearchBar() {
        placeSearchView.navigationBar.searchBar.delegate = self
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

// MARK: - Location Service Setup
extension PlaceSearchViewController {
    private func setupLocationService() {
        viewModel.locationService.delegate = self
        viewModel.locationService.requestLocation()
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

// MARK: - UISearchBarDelegate
extension PlaceSearchViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        viewModel.searchPlace(searchText)
    }
}


// MARK: - Collection View Setup and Layout
extension PlaceSearchViewController {
    private func setupCollectionView() {
        placeSearchView.searchResultsCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Collection View Data Source Configuration
extension PlaceSearchViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Place>(collectionView: placeSearchView.searchResultsCollectionView) { (collectionView, indexPath, place) -> UICollectionViewCell? in
            self.configurePlaceSearcCell(for: collectionView, at: indexPath, item: place)
        }
    }
    
    private func applySnapshot(with items: [Place]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Place>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configurePlaceSearcCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        item: Place
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? PlaceSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateContent(with: item)
        
        return cell
    }
}
