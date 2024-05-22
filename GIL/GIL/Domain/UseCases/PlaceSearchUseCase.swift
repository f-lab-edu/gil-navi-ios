//
//  PlaceSearchUseCase.swift
//  GIL
//
//  Created by 송우진 on 5/21/24.
//

import Combine
import MapKit

protocol PlaceSearchUseCase {
    func searchPlace(_ query: String, location: MapLocation) -> AnyPublisher<[MapItem], Error>
}

final class DefaultPlaceSearchUseCase: PlaceSearchUseCase {
    private let regionRadius: CLLocationDistance = 5000 // 검색할 반경(미터 단위)
    
    /// 주어진 좌표와 쿼리를 사용하여 주변 장소를 검색합니다.
    /// - Parameters:
    ///   - location: 검색을 시작할 중심 좌표를 담고 있는 객체
    ///   - query: 검색할 키워드 또는 카테고리
    ///   - regionRadius: 검색할 반경(미터 단위)
    /// - Returns: 검색된 장소의 배열(MapItem)을 반환합니다. 오류 발생 시 예외를 던집니다.
    func searchPlace(
        _ query: String,
        location: MapLocation
    ) -> AnyPublisher<[MapItem], Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self else { return }
                Task {
                    do {
                        let mapItems = try await self.searchPlacesNearby(location: location, query: query)
                        let models = mapItems.map { MapItem(mapItem: $0, distance: location.distance(to: $0.placemark.coordinate) ?? 0) }
                            .sorted(by: { $0.distance ?? 0 < $1.distance ?? 0 })
                        promise(.success(models))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
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
