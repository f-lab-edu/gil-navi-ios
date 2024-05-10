//
//  MapController.swift
//  GIL
//
//  Created by 송우진 on 5/10/24.
//

import MapKit

final class MapController: NSObject, MKMapViewDelegate {
    private var mapView: MKMapView
    
    // MARK: - Initialization
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        mapView.delegate = self
    }
}

// MARK: - MKMapViewDelegate
extension MapController {
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .mainGreen
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer()
    }
}

extension MapController {
    func createPinAnnotation(
        coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String? = nil
    ) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        return annotation
    }
    
    func addAnnotations(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    func setRegion(_ region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    func findRoute(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) in
            guard let self else { return }
            guard let response = response else { return }

            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
}
