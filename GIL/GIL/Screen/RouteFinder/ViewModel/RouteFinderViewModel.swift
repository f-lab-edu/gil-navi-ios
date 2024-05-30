//
//  RouteFinderViewModel.swift
//  GIL
//
//  Created by 송우진 on 5/11/24.
//

import Combine
import UIKit

final class RouteFinderViewModel {
    @Published var selectedTransport: Transport?
    @Published var selectedRoute: RouteModel?
    var customDetent: UISheetPresentationController.Detent?
    var cancellables: Set<AnyCancellable> = []
    
    init(selectedTransport: Transport? = nil) {
        self.selectedTransport = selectedTransport
    }
}
