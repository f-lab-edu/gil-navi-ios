//
//  HomeViewController.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit
import FirebaseAuth

struct HomeActions {
    let showPlaceSearch: () -> Void
}

protocol HomeDisplayLogic {
    func displaySearchScreen()
    func displayFetchedData(_ data: [Place])
    func displayRouteMap(place: MapItem)
}

final class HomeViewController: BaseViewController, NavigationBarHideable {
    private var interactor: HomeBusinessLogic
    private var homeView = HomeView()
    private var homeCollectionViewHandler: HomeCollectionViewHandler?
    private var actions: HomeActions?
    
    // MARK: - Initialization
    init(actions: HomeActions? = nil) {
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        interactor.presenter = presenter
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        
        self.actions = actions
        presenter.viewController = self
        homeCollectionViewHandler = HomeCollectionViewHandler(interactor: self.interactor, homeView: homeView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = homeView
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
    func displayRouteMap(place: MapItem) {
        let viewModel = RouteMapViewModel(departureMapLocation: nil, destinationMapItem: place)
        let vc = RouteMapViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func displayFetchedData(_ data: [Place]) {
        homeCollectionViewHandler?.updateSnapshot(with: data)
    }
    
    func displaySearchScreen() {
        actions?.showPlaceSearch()
    }
}


