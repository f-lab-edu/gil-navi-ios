//
//  MapLocation.swift
//  GIL
//
//  Created by 송우진 on 5/14/24.
//

import CoreLocation

struct MapLocation {
    let location: CLLocation
    let coordinate: Coordinate
    
    init(_ clLocation: CLLocation) {
        location = clLocation
        coordinate = Coordinate(
            latitude: clLocation.coordinate.latitude,
            longitude: clLocation.coordinate.longitude
        )
    }
    
    /// 내 위치와 주어진 위치 사이의 거리를 계산합니다
    /// - Parameters:
    ///   - coordinate: 거리를 계산할 대상 위치의 좌표
    /// - Returns: 두 위치 사이의 거리를 미터 단위로 반환. 위치 정보가 없는 경우 nil 반환.
    func distance(to coordinate: CLLocationCoordinate2D) -> Double? {
        let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location.distance(from: targetLocation)
    }
}
