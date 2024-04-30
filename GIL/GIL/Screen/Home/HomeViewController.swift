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
        case normal
    }
    
    private var interactor: HomeBusinessLogic
    private var homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
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

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayFetchedData(_ data: [PlaceData]) {
        data.forEach {
            Log.info("Place", [
                $0.saveDate,
                $0.place
            ])
        }
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
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = Section.allCases[sectionIndex]

            switch section {
            case .main: return NSCollectionLayoutSection(group: self.createMainGroup())
            }
        }
    }
    
    private func createMainGroup() -> NSCollectionLayoutGroup {
        let searchItemHeight: CGFloat = 80
        let searchItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(searchItemHeight))
        let searchItem = NSCollectionLayoutItem(layoutSize: searchItemSize)

        let normalItemHeight: CGFloat = 400
        let normalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(normalItemHeight))
        let normalItem = NSCollectionLayoutItem(layoutSize: normalItemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(searchItemHeight + normalItemHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [searchItem, normalItem])
        return group
    }
}

// MARK: - Collection View Data Source Configuration
extension HomeViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: homeView.mainCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .search: return self.configureSearchCell(for: collectionView, at: indexPath)
            default: return self.configureNormalCell(for: collectionView, at: indexPath)
            }
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.search, .normal], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureSearchCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeSearchCollectionViewCell else {
            return configureNormalCell(for: collectionView, at: indexPath)
        }
        
        cell.onSearchBarTapped = { [weak self] in
            guard let self else { return }
            self.interactor.performSearch()
        }
        
        return cell
    }

    private func configureNormalCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalCell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }
}
