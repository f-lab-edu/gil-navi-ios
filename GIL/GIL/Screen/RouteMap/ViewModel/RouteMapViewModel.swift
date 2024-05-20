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
    case departureLocationEmpty
}

final class RouteMapViewModel {
    let locationService = LocationService()
    var routeManager: RouteManagerProtocol?
    let departureCLLocation: CLLocationModel?
    let destination: PlaceModel

    init(
        departureCLLocation: CLLocationModel?,
        destination: PlaceModel
    ) {
        self.departureCLLocation = departureCLLocation
        self.destination = destination
    }
    
    @MainActor
    func setupMapAndFindRoutes(transportType: Transport) async throws -> [RouteModel] {
        guard let routeManager = routeManager else { throw RouteMapError.routeManagerUnavailable }
        let destinationCoordinate = destination.placemark.coordinate.toCLLocationCoordinate2D()
        
        let destinationPinAnnotation = routeManager.createPinAnnotation(coordinate: destinationCoordinate, title: destination.name, subtitle: nil)
        routeManager.addAnnotations([destinationPinAnnotation])
        
        guard let departureCoordinate = departureCLLocation?.coordinate.toCLLocationCoordinate2D() else { throw RouteMapError.departureLocationEmpty }
        
        let region = routeManager.fetchCoordinateRegion(from: departureCoordinate, to: destinationCoordinate)
        routeManager.setRegion(region)
        
        return try await routeManager.findRoute(from: departureCoordinate, to: destinationCoordinate, transportType: transportType)
    }
    
//    func setRegion() {
//        guard let routeManager = routeManager else { return }
//        let myRegion = routeManager.getRegion()
//        routeManager.setRegion(myRegion)
//    }
}
