//
//  HomeViewController+UIUpdates.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import Foundation

extension HomeViewController {
    func updateSnapshot(with data: [PlaceData]) {
        recentSearchCount = data.count
        
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .main).filter {
            if case .recentSearchPlace = $0 { return true }
            return false
        })
        let newItems = [Item.recentSearchPlace(data)]
        snapshot.appendItems(newItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        
        resetLayout()
    }
    
    private func resetLayout() {
        let newLayout = createLayout()
        homeView.mainCollectionView.setCollectionViewLayout(newLayout, animated: false)
    }
}
