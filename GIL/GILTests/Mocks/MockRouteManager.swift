//
//  MockRouteManager.swift
//  GILTests
//
//  Created by 송우진 on 5/28/24.
//

import MapKit
@testable import GIL

class MockRouteManager: RouteManaging {
    private var mapView: MKMapView?
    
    func configureMapView(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func calculateRouteAsync(from start: GIL.Coordinate, to end: GIL.Coordinate, transportType: GIL.Transport) async throws -> [GIL.Route] {
        []
    }
    
    func addRoutesPolyline(_ routes: [GIL.Route]) {
        fatalError("Not implemented")
    }
    
    func addAnnotation(at coordinate: GIL.Coordinate, title: String, subtitle: String?) {
        fatalError("Not implemented")
    }
    
    func focusMapToShowAllRoutes(routes: [GIL.Route]) {
        fatalError("Not implemented")
    }
    
    func clearMap() {
        removeAnnotations()
        removeOverlays()
    }
    
    func removeAnnotations() {
        fatalError("Not implemented")
    }
    
    func removeOverlays() {
        fatalError("Not implemented")
    }
}
