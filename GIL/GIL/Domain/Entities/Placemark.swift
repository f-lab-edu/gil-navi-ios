//
//  Placemark.swift
//  GIL
//
//  Created by 송우진 on 5/9/24.
//

import MapKit

struct Placemark: Hashable, Codable {
    let coordinate: Coordinate
    var address: String?
    var areasOfInterest: [String]?
    
    // MARK: - Initialization
    
    /// `CLPlacemark` 객체를 사용하여 `PlacemarkModel`의 새 인스턴스를 초기화합니다.
    /// - Parameter clPlacemark: `CLPlacemark` 객체
    init(clPlacemark: CLPlacemark) {
        coordinate = Coordinate(
            latitude: clPlacemark.location?.coordinate.latitude,
            longitude: clPlacemark.location?.coordinate.longitude
        )
        address = formatAddress(for: clPlacemark)
        areasOfInterest = clPlacemark.areasOfInterest
        Log.info("CL_PlacemarkModel", [
            "coordinate": coordinate,
            "address": address ?? "",
            "areasOfInterest": areasOfInterest ?? []
        ])
    }
    
    /// `MKPlacemark` 객체를 사용하여 `PlacemarkModel`의 새 인스턴스를 초기화합니다.
    /// - Parameter mkPlacemark: `MKPlacemark` 객체
    init(mkPlacemark: MKPlacemark) {
        coordinate = Coordinate(
            latitude: mkPlacemark.coordinate.latitude,
            longitude: mkPlacemark.coordinate.longitude
        )
        address = formatAddress(for: mkPlacemark)
        areasOfInterest = mkPlacemark.areasOfInterest
        Log.info("MK_PlacemarkModel", [
            "coordinate": coordinate,
            "address": address ?? "",
            "areasOfInterest": areasOfInterest ?? []
        ])
    }
}

extension Placemark {
    /// 지정된 `Placemark`에 따라 주소 문자열 반환합니다.
    /// - Parameter placemark: 주소 정보를 제공할 `CLPlacemark` 객체.
    /// - Returns: 현지화된 주소 문자열을 반환합니다. 언어 설정에 따라 주소 형식이 달라질 수 있습니다.
    private func formatAddress(for placemark: CLPlacemark) -> String {
        guard let locale = Locale.current.language.languageCode?.identifier else { return formatKoreanAddress(for: placemark) }
        let languageCode = LanguageCode(rawValue: locale) ?? .korean
        switch languageCode {
        case .japanese: return formatJapaneseAddress(for: placemark)
        case .english: return formatEnglishAddress(for: placemark)
        case .korean: return formatKoreanAddress(for: placemark)
        }
    }
    
    private func formatKoreanAddress(for placemark: CLPlacemark) -> String {
        return [
            placemark.administrativeArea, /// 주 또는 지역(州)의 이름
            placemark.locality, /// 도시의 이름
            placemark.subLocality, /// 도시 내의 하위 구역(예: 구, 동)
            placemark.thoroughfare, /// 거리의 이름
            placemark.subThoroughfare /// 거리의 상세 주소(예: 건물 번호)
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
