//
//  HomeViewController+DataSourceConfiguration.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

extension HomeViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.mainCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .search: 
                return self.configureSearchCell(for: collectionView, at: indexPath)
            case let .recentSearchPlace(placeData):
                return self.configureRecentSearchPlaceCell(for: collectionView, at: indexPath, with: placeData)
            }
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.search], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureSearchCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeSearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.onSearchBarTapped = { [weak self] in
            guard let self else { return }
            self.interactor.performSearch()
        }
        return cell
    }

    private func configureRecentSearchPlaceCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        with data: [PlaceData]
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRecentSearchPlaceCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeRecentSearchPlaceCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: data)
        return cell
    }
}
