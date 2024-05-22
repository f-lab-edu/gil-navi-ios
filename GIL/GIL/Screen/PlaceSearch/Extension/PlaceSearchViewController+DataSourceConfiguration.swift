//
//  PlaceSearchViewController+DataSourceConfiguration.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

extension PlaceSearchViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Place>(collectionView: placeSearchView.searchResultsCollectionView) { (collectionView, indexPath, place) -> UICollectionViewCell? in
            self.configurePlaceSearcCell(for: collectionView, at: indexPath, item: place)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Place>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
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
