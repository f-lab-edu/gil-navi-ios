//
//  PlaceModel.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import MapKit

struct PlaceModel: Hashable, Codable {
    let name: String
    let phoneNumber: String?
    let url: URL?
    let category: String?
    var distance: Double?
    var formattedDistance: String?
    let placemark: PlacemarkModel
    
    // MARK: - Initialization
    init(
        mapItem: MKMapItem,
        distance: Double?
    ) {
        self.name = mapItem.name ?? ""
        self.phoneNumber = mapItem.phoneNumber
        self.url = mapItem.url
        self.category = mapItem.pointOfInterestCategory?.rawValue
        self.distance = distance
        self.placemark = PlacemarkModel(mkPlacemark: mapItem.placemark)
        self.formattedDistance = formattedDistanceString()
        Log.info("PlaceModel", [
            "name":self.name,
            "phoneNumber":self.phoneNumber ?? "",
            "url": self.url?.absoluteString ?? "",
            "category": self.category ?? "",
            "distance" : self.formattedDistance
        ])
    }
    
    /// 거리를 문자열 형식으로 반환합니다.
    /// - Returns: 1000미터 미만인 경우 미터(m) 단위로, 그 이상인 경우 킬로미터(km) 단위로 반환됩니다. distance가 비어 있으면 nil을 반환합니다.
    private func formattedDistanceString() -> String? {
        guard let distance = distance else { return nil }
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            return String(format: "%.2fkm", distance / 1000)
        }
    }
}
