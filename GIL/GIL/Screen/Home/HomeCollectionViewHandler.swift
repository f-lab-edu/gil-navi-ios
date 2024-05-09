//
//  HomeCollectionViewHandler.swift
//  GIL
//
//  Created by 송우진 on 5/7/24.
//

import UIKit

final class HomeCollectionViewHandler: NSObject {
    private enum Section: CaseIterable {
        case main
    }
    private enum Item: Hashable {
        case search
        case recentSearchPlace
    }
    private var interactor: HomeBusinessLogic
    private var homeView: HomeView
    private var recentSearchPlaces: [PlaceData] = [] // 최근 검색 장소 데이터를 저장하는 배열
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    // MARK: - Initialization
    init(
        interactor: HomeBusinessLogic,
        homeView: HomeView
    ) {
        self.interactor = interactor
        self.homeView = homeView
        super.init()
        setupCollectionView()
        configureDataSource()
    }
}

// MARK: - Setup and Configuration
extension HomeCollectionViewHandler {
    private func setupCollectionView() {
        homeView.mainCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let searchItem = HomeSearchCollectionViewCell.layoutItem()
        let recentSearchItem = HomeRecentSearchPlaceCollectionViewCell.layoutItem(count: recentSearchPlaces.count)
        
        let groupHeight = searchItem.layoutSize.heightDimension.dimension + recentSearchItem.layoutSize.heightDimension.dimension
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(groupHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem, recentSearchItem])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.mainCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .search: return self.configureSearchCell(for: collectionView, at: indexPath)
            case .recentSearchPlace: return self.configureRecentSearchPlaceCell(for: collectionView, at: indexPath, with: self.recentSearchPlaces)
            }
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.search, .recentSearchPlace], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - DataSource Updates
extension HomeCollectionViewHandler {
    func updateSnapshot(with data: [PlaceData]) {
        recentSearchPlaces = data
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([.recentSearchPlace])
        dataSource.apply(snapshot, animatingDifferences: true)
        resetLayout()
    }
    
    private func resetLayout() {
        let newLayout = createLayout()
        homeView.mainCollectionView.setCollectionViewLayout(newLayout, animated: false)
    }
}

// MARK: - Cell Configuration
extension HomeCollectionViewHandler {
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
