//
//  MapItem.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import MapKit

struct MapItem: Hashable, Codable {
    let name: String
    let phoneNumber: String?
    let url: URL?
    let category: String?
    var distance: Distance
    let placemark: Placemark
    
    // MARK: - Initialization
    init(
        mapItem: MKMapItem,
        distance: Double?
    ) {
        self.name = mapItem.name ?? ""
        self.phoneNumber = mapItem.phoneNumber
        self.url = mapItem.url
        self.category = mapItem.pointOfInterestCategory?.rawValue
        self.distance = Distance(value: distance)
        self.placemark = Placemark(mkPlacemark: mapItem.placemark)
    }
}

extension MapItem {
    func formatAddressWithDistance() -> String {
        guard let address = self.placemark.address else { return "" }
        if let formattedDistance = self.distance.formatDistanceAsCompact() {
            return "\(formattedDistance) · \(address)"
        } else {
            return address
        }
    }
}

