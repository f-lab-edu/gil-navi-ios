//
//  RouteManager.swift
//  GIL
//
//  Created by 송우진 on 5/10/24.
//

import MapKit

// MARK: - RouteManagerProtocol
protocol RouteManagerProtocol {
    var selectedRoute: RouteModel? { get set }
    func createPinAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String?) -> MKPointAnnotation
    func addAnnotations(_ annotations: [MKAnnotation])
    func addRoutesPolyline(_ routes: [RouteModel])
    func setRegion(_ region: MKCoordinateRegion)
    func fetchCoordinateRegion(from departureCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) -> MKCoordinateRegion
    func findRoute(from departure: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, transportType: Transport) async throws -> [RouteModel]
}

final class RouteManager: NSObject, MKMapViewDelegate, RouteManagerProtocol {
    private var mapView: MKMapView
    var selectedRoute: RouteModel? {
        didSet {
            Task {
                await reloadOverlays()
            }
        }
    }
    
    // MARK: - Initialization
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        mapView.delegate = self
    }
}

// MARK: - MKMapViewDelegate
extension RouteManager {
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .mainGreen.withAlphaComponent(0.3)
        renderer.lineWidth = 3
        if let selectedRoute = selectedRoute, mapView.overlays.contains(where: { $0 as? MKPolyline == selectedRoute.polyline }) {
            renderer.strokeColor = (selectedRoute.polyline == polyline) ? .mainGreen : .mainGreen.withAlphaComponent(0.3)
            renderer.lineWidth = (selectedRoute.polyline == polyline) ? 4 : 3
        }
        return renderer
    }
}

extension RouteManager {
    /// 두 좌표를 이용해 MKCoordinateRegion 생성
    func fetchCoordinateRegion(
        from departureCoordinate: CLLocationCoordinate2D,
        to destinationCoordinate: CLLocationCoordinate2D
    ) -> MKCoordinateRegion {
        let centerCoordinate = midPoint(from: departureCoordinate, to: destinationCoordinate)
        let distance = calculateDistance(from: departureCoordinate, to: destinationCoordinate)
        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: distance * 1.5, longitudinalMeters: distance * 1.5)
        return region
    }
    
    /// 두 좌표의 중간 지점 계산
    private func midPoint(
        from departure: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) -> CLLocationCoordinate2D {
        let lat1 = departure.latitude * .pi / 180
        let lon1 = departure.longitude * .pi / 180
        let lat2 = destination.latitude * .pi / 180
        let dLon = (destination.longitude - departure.longitude) * .pi / 180

        let bx = cos(lat2) * cos(dLon)
        let by = cos(lat2) * sin(dLon)
        let midLat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + by * by))
        let midLon = lon1 + atan2(by, cos(lat1) + bx)

        return CLLocationCoordinate2D(latitude: midLat * 180 / .pi, longitude: midLon * 180 / .pi)
    }
    
    /// 두 좌표 사이의 거리 계산
    private func calculateDistance(
        from: CLLocationCoordinate2D,
        to: CLLocationCoordinate2D
    ) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
    
    /// 핀 어노테이션 생성후 반환합니다
    /// - Parameters:
    ///   - coordinate:
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
}

@MainActor
extension RouteManager {
    /// 맵뷰에 어노테이션을 추가합니다
    func addAnnotations(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    /// 맵뷰에 영역을 설정합니다
    func setRegion(_ region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
    
    /// 맵뷰에 경로 폴리라인을 추가합니다
    func addRoutesPolyline(_ routes: [RouteModel]) {
        let polylines = routes.map({ $0.polyline })
        mapView.addOverlays(polylines, level: .aboveRoads)
    }
    
    /// 맵뷰의 오버레이들을 새로고침합니다
    func reloadOverlays() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        mapView.addOverlays(overlays, level: .aboveRoads)
    }
    
    /// 출발지와 목적지까지 경로를 찾습니다
    /// - Parameters:
    ///  - departure: 출발지
    ///  - destination: 목적지
    ///  - transportType: 이동수단
    /// - Returns: 검색된 루트들을 반환합니다
    func findRoute(
        from departure: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        transportType: Transport
    ) async throws -> [RouteModel] {
        mapView.overlays.forEach { mapView.removeOverlay($0) }
        let departurePlacemark = MKPlacemark(coordinate: departure)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: departurePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = transportType.mkTransportType
        directionRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: directionRequest)
        return try await directions.calculate().routes.map({ RouteModel($0) })
    }
}
