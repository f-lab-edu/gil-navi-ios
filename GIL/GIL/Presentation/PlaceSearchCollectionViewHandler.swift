//
//  PlaceSearchCollectionViewHandler.swift
//  GIL
//
//  Created by 송우진 on 5/7/24.
//

import UIKit

final class PlaceSearchCollectionViewHandler: NSObject, UICollectionViewDelegate {
    private enum Section: CaseIterable {
        case main
    }
    private var viewModel: PlaceSearchViewModel
    private var placeSearchView: PlaceSearchView
    private var viewController: PlaceSearchViewController
    private var dataSource: UICollectionViewDiffableDataSource<Section, MapItem>!
    
    // MARK: - Initialization
    init(
        viewModel: PlaceSearchViewModel,
        placeSearchView: PlaceSearchView,
        viewController: PlaceSearchViewController
    ) {
        self.viewModel = viewModel
        self.placeSearchView = placeSearchView
        self.viewController = viewController
        super.init()
        setupCollectionView()
        configureDataSource()
    }
}

// MARK: - DataSource Updates
extension PlaceSearchCollectionViewHandler {
    func applySnapshot(with items: [MapItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .main))
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension PlaceSearchCollectionViewHandler {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let destination = viewModel.mapItems.value[indexPath.row]
        viewModel.storePlace(destination)
        viewModel.showRouteFinder(destination: destination)
    }
}

// MARK: - Setup and Configuration
extension PlaceSearchCollectionViewHandler {
    private func setupCollectionView() {
        placeSearchView.searchResultsCollectionView.delegate = self
        placeSearchView.searchResultsCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let placeItem = PlaceSearchCollectionViewCell.layoutItem()
        let group = NSCollectionLayoutGroup.vertical(layoutSize: placeItem.layoutSize, subitems: [placeItem])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MapItem>(collectionView: placeSearchView.searchResultsCollectionView) { (collectionView, indexPath, place) -> UICollectionViewCell? in
            self.configurePlaceSearcCell(for: collectionView, at: indexPath, item: place)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MapItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Cell Configuration
extension PlaceSearchCollectionViewHandler {
    private func configurePlaceSearcCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        item: MapItem
    ) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? PlaceSearchCollectionViewCell
        cell?.updateContent(with: item)
        return cell
    }
}
