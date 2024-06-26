//
//  LocationService.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didFetchPlacemark(_ placemark: Placemark)
    func didFailWithError(_ error: Error)
}

protocol LocationServiceProtocol {
    var delegate: LocationServiceDelegate? { get set }
    var currentLocation: MapLocation? { get }
    
    /// 위치 서비스 사용 권한을 요청하고 위치 업데이트를 시작합니다.
    func requestLocation()
    
    /// 위치 업데이트를 중단합니다.
    func stopUpdatingLocation()
}

class LocationService: NSObject, LocationServiceProtocol {
    weak var delegate: LocationServiceDelegate?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var currentLocation: MapLocation?
    
    // MARK: - Initialization
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 매우 높은 정확도
    }
    
    // MARK: - Location Management
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Address Fetching
    func fetchAddress(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            if let placemark = placemarks?.first {
                let model = Placemark(clPlacemark: placemark)
                self.delegate?.didFetchPlacemark(model)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    /// 위치 업데이트 성공 시 호출됩니다.
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            currentLocation = MapLocation(location)
            fetchAddress(for: location)
        }
    }
    
    /// 위치 업데이트 실패 시 호출됩니다.
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        delegate?.didFailWithError(error)
    }
}
