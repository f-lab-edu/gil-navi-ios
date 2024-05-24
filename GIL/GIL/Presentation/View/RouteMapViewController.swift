//
//  RouteMapViewController.swift
//  GIL
//
//  Created by 송우진 on 5/8/24.
//

import UIKit

final class RouteMapViewController: BaseViewController, NavigationBarHideable {
    private var routeMapView = RouteMapView()
    private var viewModel: RouteMapViewModel
    
    // MARK: - Initialization
    init(viewModel: RouteMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.configureMapView(mapView: routeMapView.mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = routeMapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        
        if viewModel.departureMapLocation != nil {
            viewModel.showRouteFinderPageSheet()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
        presentedViewController?.dismiss(animated: true)
    }
}

// MARK: - Setup Binding
extension RouteMapViewController {
    private func setupBindings() {
        bindButtons()
    }
    
    private func bindButtons() {
        routeMapView.backButton.addAction(UIAction { [weak self] _ in self?.popViewController()}, for: .touchUpInside)
    }

}

// MARK: - Navigation
extension RouteMapViewController {
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - PathFinderPageSheetDelegate
extension RouteMapViewController: RouteFinderSheetViewControllerDelegate {
    
    func didSelectRoute(
        sender: RouteFinderSheetViewController,
        routes: [Route]
    ) {
        viewModel.updateRoutesPolyline(routes: routes)
    }
    
    func requestRouteUpdate(
        sender: RouteFinderSheetViewController,
        transportType: Transport
    ) {
        Task {
            let routes = await viewModel.fetchAndDisplayRoutes(transportType: transportType)
            await MainActor.run {
                sender.updateRoutes(routes)
            }
        }
    }
}

// MARK: - MKMapViewDelegate
//extension RouteMapViewController: MKMapViewDelegate {
//    func mapView(
//        _ mapView: MKMapView,
//        didUpdate userLocation: MKUserLocation
//    ) {
//        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
//        mapView.setRegion(region, animated: true)
//    }
//}
