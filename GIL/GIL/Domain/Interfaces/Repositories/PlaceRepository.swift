//
//  PlaceRepository.swift
//  GIL
//
//  Created by 송우진 on 5/26/24.
//

import Foundation

protocol PlaceRepository {
    func storePlace(_ mapItem: MapItem)
    func fetchPlaces(limit: Int, order: SortOrder) -> [Place]
}
