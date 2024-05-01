//
//  HomeViewController.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit

protocol HomeDisplayLogic {
    func displaySearchScreen()
    func displayFetchedData(_ data: [PlaceData])
}

final class HomeViewController: BaseViewController, NavigationBarHideable {
    enum Section: CaseIterable {
        case main
    }
    
    enum Item: Hashable {
        case search
        case recentSearchPlace([PlaceData])
    }
    
    private var interactor: HomeBusinessLogic
    private var homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private var recentSearchCount = 0 // 최근 검색 개수를 추적하는 변수
    
    // MARK: - Initialization
    init(interactor: HomeBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
        interactor.fetchPlaceData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
    }
}

// MARK: - UI Updates
extension HomeViewController {
    private func updateSnapshot(with data: [PlaceData]) {
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

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayFetchedData(_ data: [PlaceData]) {
        updateSnapshot(with: data)
    }
    
    func displaySearchScreen() {
        let searchDetailVC = PlaceSearchViewController(viewModel: PlaceSearchViewModel())
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}

// MARK: - Collection View Setup and Layout
extension HomeViewController {
    private func setupCollectionView() {
        homeView.mainCollectionView.collectionViewLayout = createLayout()
    }

    private func createLayout() -> UICollectionViewLayout {
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

// MARK: - Collection View Data Source Configuration
extension HomeViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.mainCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .search: return self.configureSearchCell(for: collectionView, at: indexPath)
            case let .recentSearchPlace(placeData): return self.configureRecentSearchPlaceCell(for: collectionView, at: indexPath, with: placeData)
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
