//
//  RouteFinderSheetViewModel.swift
//  GIL
//
//  Created by 송우진 on 5/11/24.
//

import Combine
import UIKit

protocol RouteFinderSheetViewModelInput {
    func updateRoutes(selectedRoute: Route)
    var customDetent: UISheetPresentationController.Detent? { get set }
}

protocol RouteFinderSheetViewModelOutput {
    var routes: CurrentValueSubject<[Route], Never> { get }
    var selectedTransport: CurrentValueSubject<Transport?, Never> { get }
}

typealias RouteFinderSheetViewModel = RouteFinderSheetViewModelInput & RouteFinderSheetViewModelOutput

final class DefaultRouteFinderSheetViewModel: RouteFinderSheetViewModel {
    // MARK: - Output
    var selectedTransport = CurrentValueSubject<Transport?, Never>(nil)
    var routes = CurrentValueSubject<[Route], Never>([])
    
    // MARK: - Input
    var customDetent: UISheetPresentationController.Detent?
    
    // MARK: - Initialization
    init(selectedTransport: Transport? = nil) {
        self.selectedTransport.send(selectedTransport)
    }
}

// MARK: - Input
extension DefaultRouteFinderSheetViewModel {
    func updateRoutes(selectedRoute: Route) {
        routes.send(routes.value.map({
            let modifiedRoute = $0
            modifiedRoute.polyline.isSelected = ($0 == selectedRoute)
            return modifiedRoute
        }))
    }
}
