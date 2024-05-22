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
        self.formattedDistance = distance?.formattedDistanceCompact()
        Log.info("PlaceModel", [
            "name":self.name,
            "phoneNumber":self.phoneNumber ?? "",
            "url": self.url?.absoluteString ?? "",
            "category": self.category ?? "",
            "distance" : self.formattedDistance
        ])
    }
}
