//
//  PlaceSearchUseCase.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import MapKit

protocol PlaceSearchUseCase {
    func searchPlaceAsync(_ query: String, location: MapLocation) async throws -> [MapItem]
}

final class DefaultPlaceSearchUseCase: PlaceSearchUseCase {
    private let regionRadius: CLLocationDistance = 5000 // 검색할 반경(미터 단위)
    
    /// 주어진 좌표와 쿼리를 사용하여 주변 장소를 검색합니다.
    /// - Parameters:
    ///   - query: 검색할 키워드 또는 카테고리
    ///   - location: 검색을 시작할 중심 좌표를 담고 있는 객체
    /// - Returns: 검색된 장소의 배열(MapItem)을 반환합니다. 오류 발생 시 예외를 던집니다.
    func searchPlaceAsync(
        _ query: String,
        location: MapLocation
    ) async throws -> [MapItem] {
        let mapItems = try await searchPlacesNearby(location: location, query: query)
        let models = mapItems
            .map { MapItem(mapItem: $0, distance: location.distance(to: $0.placemark.coordinate) ?? 0) }
            .sorted(by: { $0.distance.value ?? 0 < $1.distance.value ?? 0 })
        return models
    }
    
    // MARK: - Private
    private func searchPlacesNearby(
        location: MapLocation,
        query: String
    ) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: location.location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        return response.mapItems.filter({
            if let itemLocation = $0.placemark.location {
                return location.location.distance(from: itemLocation) <= regionRadius
            }
            return false
        })
    }
}
