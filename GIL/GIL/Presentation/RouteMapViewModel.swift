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
    let departureMapLocation: MapLocation?
    let destinationMapItem: MapItem

    init(
        departureMapLocation: MapLocation?,
        destinationMapItem: MapItem
    ) {
        self.departureMapLocation = departureMapLocation
        self.destinationMapItem = destinationMapItem
    }
    
    @MainActor
    func setupMapAndFindRoutes(transportType: Transport) async throws -> [Route] {
        guard let routeManager = routeManager else { throw RouteMapError.routeManagerUnavailable }
        let destinationCoordinate = destinationMapItem.placemark.coordinate.toCLLocationCoordinate2D()
        
        let destinationPinAnnotation = routeManager.createPinAnnotation(coordinate: destinationCoordinate, title: destinationMapItem.name, subtitle: nil)
        routeManager.addAnnotations([destinationPinAnnotation])
        
        guard let departureCoordinate = departureMapLocation?.coordinate.toCLLocationCoordinate2D() else { throw RouteMapError.departureLocationEmpty }
        
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
