//
//  RouteMapViewModel.swift
//  GIL
//
//  Created by 송우진 on 5/8/24.
//

import Foundation

// MARK: - RouteFinderError
enum RouteMapError: Error {
    case routeManagerUnavailable
}

final class RouteMapViewModel {
    var routeManager: RouteManagerProtocol?
    let currentCLLocation: CLLocationModel
    let destination: PlaceModel

    init(
        currentCLLocation: CLLocationModel,
        destination: PlaceModel
    ) {
        self.currentCLLocation = currentCLLocation
        self.destination = destination
    }
    
    @MainActor
    func setupMapAndFindRoutes(transportType: Transport) async throws -> [RouteModel] {
        guard let routeManager = routeManager else { throw RouteMapError.routeManagerUnavailable }
        let departureCoordinate = currentCLLocation.coordinate.toCLLocationCoordinate2D()
        let destinationCoordinate = destination.placemark.coordinate.toCLLocationCoordinate2D()
        
        let pinAnnotation = routeManager.createPinAnnotation(coordinate: destinationCoordinate, title: destination.name, subtitle: nil)
        routeManager.addAnnotations([pinAnnotation])
        
        let region = routeManager.fetchCoordinateRegion(from: departureCoordinate, to: destinationCoordinate)
        routeManager.setRegion(region)
        
        return try await routeManager.findRoute(from: departureCoordinate, to: destinationCoordinate, transportType: transportType)
    }
}
