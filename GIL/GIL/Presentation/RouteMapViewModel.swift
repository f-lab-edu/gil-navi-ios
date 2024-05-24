//
//  RouteMapViewModel.swift
//  GIL
//
//  Created by 송우진 on 5/8/24.
//

import Combine
import MapKit

struct RouteMapViewModelActions {
    let showRouteFinderPageSheet: () -> Void
}

enum RouteMapError: Error {
    case routeManagerUnavailable
    case departureLocationEmpty
}

protocol RouteMapViewModelInput {
    var departureMapLocation: MapLocation? { get }
    func showRouteFinderPageSheet()
    func configureMapView(mapView: MKMapView)
    func fetchAndDisplayRoutes(transportType: Transport) async -> [Route]?
    func updateRoutesPolyline(routes: [Route])
}

protocol RouteMapViewModelOutput {}

typealias RouteMapViewModel = RouteMapViewModelInput & RouteMapViewModelOutput

final class DefaultRouteMapViewModel: RouteMapViewModel {
    private let routeFinderUseCase: RouteFinderUseCase
    private let actions: RouteMapViewModelActions?
    private var cancellables: Set<AnyCancellable> = []
    private let destinationMapItem: MapItem
    
    // MARK: - Input
    let departureMapLocation: MapLocation?

    // MARK: - Initialization
    init(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem,
        routeFinderUseCase: RouteFinderUseCase,
        actions: RouteMapViewModelActions
    ) {
        self.departureMapLocation = departureMapLocation
        self.destinationMapItem = destinationMapItem
        self.routeFinderUseCase = routeFinderUseCase
        self.actions = actions
    }
    
    // MARK: - Private
    private func handleError(_ error: Error) {
        
    }
}

// MARK: - Input
extension DefaultRouteMapViewModel {
    func showRouteFinderPageSheet() {
        actions?.showRouteFinderPageSheet()
    }
    
    func configureMapView(mapView: MKMapView) {
        routeFinderUseCase.configureMapView(mapView: mapView)
    }
    
    func updateRoutesPolyline(routes: [Route]) {
        routeFinderUseCase.updateRoutesPolyline(routes: routes)
    }
    
    func fetchAndDisplayRoutes(transportType: Transport) async -> [Route]? {
        do {
            guard let departureCoordinate = departureMapLocation?.coordinate else { throw RouteMapError.departureLocationEmpty }
            let routes = try await routeFinderUseCase.setupRouteAndDisplay(from: departureCoordinate, to: destinationMapItem, transportType: transportType)
            return routes
        } catch {
            handleError(error)
            return nil
        }
    }
}
