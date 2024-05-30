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
    func displayRouteMap(place: PlaceModel)
}

final class HomeViewController: BaseViewController, NavigationBarHideable {
    private var interactor: HomeBusinessLogic
    private var homeView = HomeView()
    private var homeCollectionViewHandler: HomeCollectionViewHandler?
    
    // MARK: - Initialization
    init() {
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        interactor.presenter = presenter
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
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
    func displayRouteMap(place: PlaceModel) {
        let viewModel = RouteMapViewModel(currentCLLocation: nil, destination: place)
        let vc = RouteMapViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func displayFetchedData(_ data: [PlaceData]) {
        homeCollectionViewHandler?.updateSnapshot(with: data)
    }
    
    func displaySearchScreen() {
        let searchDetailVC = PlaceSearchViewController(viewModel: PlaceSearchViewModel())
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}


