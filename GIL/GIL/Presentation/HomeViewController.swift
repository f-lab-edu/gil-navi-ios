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
    let showRouteFinder: (MapItem) -> Void
}

protocol HomeDisplayLogic {
    func displaySearchScreen()
    func displayFetchedPlaces(_ data: [Place])
    func displayRouteMap(place: MapItem)
}

final class HomeViewController: BaseViewController, NavigationBarHideable {
    private var interactor: HomeBusinessLogic
    private var homeView = HomeView()
    private var homeCollectionViewHandler: HomeCollectionViewHandler?
    private var actions: HomeActions?
    
    // MARK: - Initialization
    init(
        interactor: HomeInteractor,
        presenter: HomePresenter,
        actions: HomeActions? = nil)
    {
        interactor.presenter = presenter
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        presenter.viewController = self
        self.actions = actions
        homeCollectionViewHandler = HomeCollectionViewHandler(
            interactor: self.interactor,
            homeView: homeView
        )
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
        interactor.fetchPlaces()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
    }
}

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displayRouteMap(place: MapItem) {
        actions?.showRouteFinder(place)
    }
    
    func displayFetchedPlaces(_ data: [Place]) {
        homeCollectionViewHandler?.updateSnapshot(with: data)
    }
    
    func displaySearchScreen() {
        actions?.showPlaceSearch()
    }
}


