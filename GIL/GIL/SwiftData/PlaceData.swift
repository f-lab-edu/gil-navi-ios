//
//  PlaceData.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import Foundation
import SwiftData

@Model
final class PlaceData {
    var saveDate: Date
    var place: Place
    
    init(
        saveDate: Date,
        place: Place
    ) {
        self.saveDate = saveDate
        self.place = place
    }
}
