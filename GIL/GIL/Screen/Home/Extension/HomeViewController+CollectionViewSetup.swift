//
//  HomeViewController+CollectionViewSetup.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

extension HomeViewController {
    func setupCollectionView() {
        homeView.mainCollectionView.collectionViewLayout = createLayout()
    }

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .main: return self.createMainSection()
            }
        }
    }

    private func createMainSection() -> NSCollectionLayoutSection {
        let searchItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let searchItem = NSCollectionLayoutItem(layoutSize: searchItemSize)
        
        let recentSearchItemHeight = CGFloat(50 * recentSearchCount)
        let recentSearchItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(recentSearchItemHeight))
        let recentSearchItem = NSCollectionLayoutItem(layoutSize: recentSearchItemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(230))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem, recentSearchItem])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return section
    }
}
