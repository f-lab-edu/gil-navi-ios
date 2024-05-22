//
//  RouteMapViewController.swift
//  GIL
//
//  Created by 송우진 on 5/8/24.
//

import UIKit
import MapKit

final class RouteMapViewController: BaseViewController, NavigationBarHideable {
    private var routeMapView = RouteMapView()
    private var viewModel: RouteMapViewModel
    private let routeFinderViewModel = RouteFinderViewModel(selectedTransport: .walking)
    private lazy var routeFinderPageSheet = RouteFinderPageSheet(viewModel: routeFinderViewModel)
    
    // MARK: - Initialization
    init(viewModel: RouteMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.routeManager = RouteManager(mapView: routeMapView.mapView)
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
            presentRouteFinderPageSheet()
        } else {
            routeMapView.mapView.delegate = self
//            viewModel.setRegion()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
    }
}

// MARK: - Setup Binding
extension RouteMapViewController {
    private func setupBindings() {
        routeFinderPageSheet.delegate = self
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
    
    func presentRouteFinderPageSheet() {
        present(routeFinderPageSheet, animated: true, completion: nil)
    }
}

// MARK: - PathFinderPageSheetDelegate
extension RouteMapViewController: RouteFinderPageSheetDelegate {
    func didSelectRoute(route: Route) {
        routeFinderPageSheet.updateCellLayer(route: route)
        routeFinderPageSheet.updateDetent()
        viewModel.routeManager?.selectedRoute = route
    }
    
    func requestRouteUpdate(transportType: Transport) {
        Task {
            do {
                let routes = try await viewModel.setupMapAndFindRoutes(transportType: transportType)
                viewModel.routeManager?.addRoutesPolyline(routes)
                routeFinderPageSheet.updateRoutes(routes)
            } catch {
                Log.error("길 찾기 실패", [
                    "transportType" : transportType.rawValue,
                    "error" : error
                ])
                routeFinderPageSheet.updateRoutes(nil)
            }
        }
    }
}

// MARK: - MKMapViewDelegate
extension RouteMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}
