//
//  PlaceSearchViewModel.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import Foundation
import Combine

struct PlaceSearchViewModelActions {
    let showRouteFinder: (MapLocation?, MapItem) -> Void
}

enum PlaceSearchError: Error {
    case locationUnavailable
    case searchFailed
}

protocol PlaceSearchViewModelInput {
    var locationService: LocationService { get }
    func storePlace(_ mapItem: MapItem)
    func searchPlace(_ query: String)
    func showRouteFinder(destination item: MapItem)
}

protocol PlaceSearchViewModelOutput {
    var mapItems: CurrentValueSubject<[MapItem], Never> { get }
    var errors: PassthroughSubject<PlaceSearchError, Never> { get }
}

typealias PlaceSearchViewModel = PlaceSearchViewModelInput & PlaceSearchViewModelOutput

final class DefaultPlaceSearchViewModel: PlaceSearchViewModel {
    private let placeSearchUseCase: PlaceSearchUseCase
    private var placeRepository: PlaceRepository
    private let actions: PlaceSearchViewModelActions?
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Input
    let locationService: LocationService
    
    // MARK: - Output
    var mapItems = CurrentValueSubject<[MapItem], Never>([])
    var errors = PassthroughSubject<PlaceSearchError, Never>()
    
    // MARK: - Initialization
    init(
        placeSearchUseCase: PlaceSearchUseCase,
        placeRepository: PlaceRepository,
        actions: PlaceSearchViewModelActions,
        locationService: LocationService
    ) {
        self.placeSearchUseCase = placeSearchUseCase
        self.placeRepository = placeRepository
        self.actions = actions
        self.locationService = locationService
    }
}

// MARK: - Input
extension DefaultPlaceSearchViewModel {
    func searchPlace(_ query: String) {
        guard let location = locationService.currentLocation else { return }
        placeSearchUseCase.searchPlace(query, location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    Log.error("Error searching place", error.localizedDescription)
                    self?.errors.send(.searchFailed)
                }
            }, receiveValue: { [weak self] placeModels in
                self?.mapItems.value = placeModels
            })
            .store(in: &cancellables)
    }
    
    func storePlace(_ mapItem: MapItem) {
        placeRepository.storePlace(mapItem)
    }
    
    func showRouteFinder(destination item: MapItem) {
        actions?.showRouteFinder(locationService.currentLocation, item)
    }
}
