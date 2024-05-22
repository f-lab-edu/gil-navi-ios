//
//  Place.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import Foundation
import SwiftData

@Model
final class Place {
    var saveDate: Date
    var mapItem: MapItem
    
    init(
        saveDate: Date,
        mapItem: MapItem
    ) {
        self.saveDate = saveDate
        self.mapItem = mapItem
    }
}
