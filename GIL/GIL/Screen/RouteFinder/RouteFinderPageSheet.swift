//
//  RouteFinderPageSheet.swift
//  GIL
//
//  Created by 송우진 on 5/11/24.
//

import UIKit

// MARK: - RouteFinderPageSheetDelegate
protocol RouteFinderPageSheetDelegate: AnyObject {
    func requestRouteUpdate(transportType: Transport)
    func didSelectRoute(route: RouteModel)
}

final class RouteFinderPageSheet: UIViewController {
    weak var delegate: RouteFinderPageSheetDelegate?
    private var routeFinderView = RouteFinderView()
    private var viewModel: RouteFinderViewModel
    private var routeCollectionController: RouteCollectionController?

    // MARK: - Initialization
    init(viewModel: RouteFinderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        routeCollectionController = RouteCollectionController(viewModel: viewModel, routeFinderView: routeFinderView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = routeFinderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageSheet()
        setupBindings()
    }
}

// MARK: - UI Updates
extension RouteFinderPageSheet {
    func updateRoutes(_ routes: [RouteModel]?) {
        guard let routes = routes else { return }
        routeCollectionController?.applySnapshot(with: routes)
        viewModel.selectedRoute = routes.first
    }
    
    func updateCellLayer(route: RouteModel?) {
        guard let route = route else { return }
        routeCollectionController?.updateCellLayer(route)
    }

    func updateDetent() {
        guard let customDetent = viewModel.customDetent else { return }
        if let sheet = sheetPresentationController, sheet.detents.contains(.large()) {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = customDetent.identifier
            }
        }
    }
}

// MARK: - Setup Bindig
extension RouteFinderPageSheet {
    private func setupBindings() {
        bindButtons()
        subscribeToPublishers()
    }
    
    private func bindButtons() {
        routeFinderView.transportButtons.forEach { [weak self] button in
            let action = UIAction { [weak self] _ in self?.transportButtonTapped(button) }
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    private func subscribeToPublishers() {
        setupBindSelectedTransport()
        setupBindSelectedRoute()
    }
    
    private func setupBindSelectedTransport() {
        viewModel.$selectedTransport
            .receive(on: DispatchQueue.main)
            .compactMap{ $0}
            .sink { [weak self] transport in
                guard let self else { return }
                routeFinderView.updateButtonStates(transport: transport)
                delegate?.requestRouteUpdate(transportType: transport)
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupBindSelectedRoute() {
        viewModel.$selectedRoute
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] route in
                guard let self, let route = route else { return }
                delegate?.didSelectRoute(route: route)
            }
            .store(in: &viewModel.cancellables)
    }
}

// MARK: - Action
extension RouteFinderPageSheet {
    private func transportButtonTapped(_ selectedButton: UIButton) {
        guard let identifier = selectedButton.accessibilityIdentifier,
              let transport = Transport(rawValue: identifier)
        else { return }
        viewModel.selectedTransport = transport
    }
}

// MARK: - Configure
extension RouteFinderPageSheet {
    private func configurePageSheet() {
        modalPresentationStyle = .pageSheet
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
            viewModel.customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier, resolver: { _ in return  200})
            guard let customDetent = viewModel.customDetent else { return }
            sheet.detents = [customDetent, .large()]
            sheet.largestUndimmedDetentIdentifier = .init(detentIdentifier)
            sheet.prefersGrabberVisible = true
        }
    }
}
