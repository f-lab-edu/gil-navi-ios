//
//  RouteManager.swift
//  GIL
//
//  Created by 송우진 on 5/10/24.
//

import MapKit

protocol RouteManaging {
    func configureMapView(mapView: MKMapView)
    func calculateRouteAsync(from start: Coordinate, to end: Coordinate, transportType: Transport) async throws -> [Route]
    func addRoutesPolyline(_ routes: [Route])
    func addAnnotation(at coordinate: Coordinate, title: String, subtitle: String?)
    func focusMapToShowAllRoutes(routes: [Route])
    func clearMap()
    func removeAnnotations()
    func removeOverlays()
}

final class RouteManager: NSObject, RouteManaging {
    private var mapView: MKMapView? {
        didSet {
            mapView?.delegate = self
        }
    }
    
    func configureMapView(mapView: MKMapView) {
        self.mapView = mapView
    }
    
    func calculateRouteAsync(
        from start: Coordinate,
        to end: Coordinate,
        transportType: Transport
    ) async throws -> [Route] {
        let directionRequest = MKDirections.Request()
        directionRequest.source = start.toMKMapItem()
        directionRequest.destination = end.toMKMapItem()
        directionRequest.transportType = transportType.mkTransportType
        directionRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: directionRequest)
        return try await directions.calculate().routes.map({ Route($0) })
    }
    
    @MainActor
    func focusMapToShowAllRoutes(routes: [Route]) {
        let mapRects = routes.map { $0.polyline.boundingMapRect }
        let combinedMapRect = mapRects.reduce(MKMapRect.null) { $0.union($1) }
        mapView?.setVisibleMapRect(combinedMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 100, right: 50), animated: true)
    }
    
    @MainActor
    func addRoutesPolyline(_ routes: [Route]) {
        let polylines = routes.map({ $0.polyline })
        mapView?.addOverlays(polylines, level: .aboveRoads)
    }
    
    @MainActor
    func addAnnotation(
        at coordinate: Coordinate,
        title: String,
        subtitle: String? = nil
    ) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate.toCLLocationCoordinate2D()
        annotation.title = title
        annotation.subtitle = subtitle
        mapView?.addAnnotation(annotation)
    }
    
    @MainActor
    func clearMap() {
        removeAnnotations()
        removeOverlays()
    }
    
    @MainActor
    func removeAnnotations() {
        mapView?.removeAnnotations(mapView?.annotations ?? [])
    }
    
    @MainActor
    func removeOverlays() {
        mapView?.removeOverlays(mapView?.overlays ?? [])
    }
    
    
}

// MARK: - MKMapViewDelegate
extension RouteManager: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        guard let polyline = overlay as? CustomPolyline else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 5
        renderer.strokeColor = polyline.isSelected ? .mainGreen : .mainGreen.withAlphaComponent(0.25)
        return renderer
    }
}
