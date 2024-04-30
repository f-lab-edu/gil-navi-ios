//
//  LocationService.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func didFetchAddress(_ address: String)
    func didFailWithError(_ error: Error)
}

class LocationService: NSObject {
    weak var delegate: LocationServiceDelegate?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var currentLocation: CLLocation?
    
    // MARK: - Initialization
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 매우 높은 정확도
    }
}

// MARK: - Location Management
extension LocationService {
    /// 위치 서비스 사용 권한을 요청하고 위치 업데이트를 시작합니다.
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /// 위치 업데이트를 중단합니다.
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    /// 내 위치와 주어진 위치 사이의 거리를 계산합니다.
    /// - Parameters:
    ///   - coordinate: 거리를 계산할 대상 위치의 좌표
    /// - Returns: 두 위치 사이의 거리를 미터 단위로 반환. 위치 정보가 없는 경우 nil 반환.
    func distance(to coordinate: CLLocationCoordinate2D) -> Double? {
        guard let currentLocation = currentLocation else { return nil }
        let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return currentLocation.distance(from: targetLocation)
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
            currentLocation = location
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

// MARK: - Address Fetching
extension LocationService {
    /// 결과 주소를 가져옵니다.
    private func fetchAddress(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                self.delegate?.didFailWithError(error)
                return
            }
            
            if let placemark = placemarks?.first {
                let formattedAddress = self.formatAddress(for: placemark)
                self.delegate?.didFetchAddress(formattedAddress)
            }
        }
    }
    
    /// Placemark에서 얻은 데이터를 기반으로 주소를 형식에 맞게 구성합니다.
    private func formatAddress(for placemark: CLPlacemark) -> String {
        guard let locale = Locale.current.language.languageCode?.identifier else {
            return formatKoreanAddress(for: placemark)
        }

        let languageCode = LanguageCode(rawValue: locale) ?? .Korean
        switch languageCode {
        case .Japanese: return formatJapaneseAddress(for: placemark)
        case .English: return formatEnglishAddress(for: placemark)
        case .Korean: return formatKoreanAddress(for: placemark)
        }
    }
    
    private func formatKoreanAddress(for placemark: CLPlacemark) -> String {
        return [
            placemark.administrativeArea,
            placemark.locality,
            placemark.subLocality,
            placemark.thoroughfare,
            placemark.subThoroughfare
        ].compactMap { $0 }.joined(separator: " ")
    }
    
    private func formatEnglishAddress(for placemark: CLPlacemark) -> String {
        return [
            placemark.subThoroughfare,
            placemark.thoroughfare,
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea
        ].compactMap { $0 }.joined(separator: ", ")
    }
    
    private func formatJapaneseAddress(for placemark: CLPlacemark) -> String {
        return [
            placemark.administrativeArea,
            placemark.locality,
            placemark.subLocality,
            placemark.thoroughfare,
            placemark.subThoroughfare
        ].compactMap { $0 }.joined(separator: "")
    }
}
