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
    
    var interactor: HomeBusinessLogic
    var homeView = HomeView()
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var recentSearchCount = 0 // 최근 검색 개수를 추적하는 변수
    
    // MARK: - Initialization
    init() {
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        interactor.presenter = presenter
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        
        presenter.viewController = self
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
        updateSnapshot(with: data)
    }
    
    func displaySearchScreen() {
        let searchDetailVC = PlaceSearchViewController(viewModel: PlaceSearchViewModel())
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}
