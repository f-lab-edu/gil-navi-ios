//
//  PlacesSearchService.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import MapKit

class PlacesSearchService {
    /// 주어진 좌표와 쿼리를 사용하여 주변 장소를 검색합니다.
    /// - Parameters:
    ///   - coordinate: 검색을 시작할 중심 좌표
    ///   - query: 검색할 키워드 또는 카테고리
    ///   - regionRadius: 검색할 반경(미터 단위)
    /// - Returns: 검색된 장소의 배열(MKMapItem)을 반환합니다. 오류 발생 시 예외를 던집니다.
    func searchPlacesNearby(
        location: CLLocation,
        query: String,
        regionRadius: CLLocationDistance = 1000
    ) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        return response.mapItems.filter({
            if let itemLocation = $0.placemark.location {
                return location.distance(from: itemLocation) <= regionRadius
            }
            return false
        })
    }
}
