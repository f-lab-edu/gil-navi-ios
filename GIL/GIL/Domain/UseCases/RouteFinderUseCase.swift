//
//  RouteFinderUseCase.swift
//  GIL
//
//  Created by 송우진 on 5/23/24.
//

import MapKit

protocol RouteFinderUseCase {
    func configureMapView(mapView: MKMapView)
    func setupRouteAndDisplay(from start: Coordinate, to end: MapItem, transportType: Transport) async throws -> [Route]
    func updateRoutesPolyline(routes: [Route])
}

final class DefaultRouteFinderUseCase: RouteFinderUseCase {
    var routeManager: RouteManaging
    
    init(routeManager: RouteManaging) {
        self.routeManager = routeManager
    }
    
    func configureMapView(mapView: MKMapView) {
        routeManager.configureMapView(mapView: mapView)
    }
    
    func updateRoutesPolyline(routes: [Route]) {
        routeManager.removeOverlays()
        routeManager.addRoutesPolyline(routes)
        postAccessibilitySelectRoute()
    }
    
    func setupRouteAndDisplay(
        from start: Coordinate,
        to end: MapItem,
        transportType: Transport
    ) async throws -> [Route] {
        let endCoordinate = end.placemark.coordinate
        let routes = try await routeManager.calculateRouteAsync(from: start, to: endCoordinate, transportType: transportType)
        routes.first?.polyline.isSelected = true
        await MainActor.run {
            routeManager.clearMap()
            routeManager.addRoutesPolyline(routes)
            routeManager.addAnnotation(at: endCoordinate, title: end.name, subtitle: nil)
            routeManager.focusMapToShowAllRoutes(routes: routes)
        }
        return routes
    }
}

// MARK: - Accessibility
extension DefaultRouteFinderUseCase {
    private func postAccessibilitySelectRoute() {
        UIAccessibility.post(notification: .announcement, argument: "선택한 경로로 변경되었습니다")
    }
}
