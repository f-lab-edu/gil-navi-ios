//
//  PlaceModel.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import MapKit

struct Place: Hashable, Codable {
    let name: String
    let category: String
    let distance: Double
    let placemarkData: PlacemarkData
    
    struct PlacemarkData: Hashable, Codable {
        let coordinate: Coordinate
        let address: String?
        let locality: String?
        let postalCode: String?
        
        init(placemark: MKPlacemark) {
            self.coordinate = Coordinate(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
            self.address = placemark.title
            self.locality = placemark.locality
            self.postalCode = placemark.postalCode
        }
        
        struct Coordinate: Codable, Hashable {
            let latitude: Double
            let longitude: Double
        }
    }
    
    init(
        mapItem: MKMapItem,
        distance: Double = 0.0
    ) {
        self.name = mapItem.name ?? ""
        self.category = mapItem.pointOfInterestCategory?.rawValue ?? ""
        self.distance = distance
        self.placemarkData = PlacemarkData(placemark: mapItem.placemark)
    }
    
    func formattedDistanceString() -> String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            return String(format: "%.2fkm", distance / 1000)
        }
    }
}
