//
//  RouteFinderSheetViewController.swift
//  GIL
//
//  Created by 송우진 on 5/11/24.
//

import UIKit
import Combine

protocol RouteFinderSheetViewControllerDelegate: AnyObject {
    func requestRouteUpdate(sender: RouteFinderSheetViewController, transportType: Transport)
    func didSelectRoute(sender: RouteFinderSheetViewController, routes: [Route])
}

final class RouteFinderSheetViewController: UIViewController {
    weak var delegate: RouteFinderSheetViewControllerDelegate?
    
    private var routeFinderSheetView = RouteFinderSheetView()
    private var viewModel: RouteFinderSheetViewModel
    private var routeFinderSheetCollectionController: RouteFinderSheetCollectionController?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization
    init(viewModel: RouteFinderSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        routeFinderSheetCollectionController = RouteFinderSheetCollectionController(
            viewModel: viewModel,
            routeFinderSheetView: routeFinderSheetView
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = routeFinderSheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageSheet()
        setupBindings()
    }
}

// MARK: - UI Updates
extension RouteFinderSheetViewController {
    func updateRoutes(_ routes: [Route]?) {
        guard let routes = routes else { return }
        viewModel.routes.send(routes)
        routeFinderSheetCollectionController?.applySnapshot(with: routes)
    }
    
    private func updateCellLayer(routes: [Route]) {
        routeFinderSheetCollectionController?.updateCellLayer(routes)
    }

    private func updateDetent() {
        guard let customDetent = viewModel.customDetent else { return }
        if let sheet = sheetPresentationController, sheet.detents.contains(.large()) {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = customDetent.identifier
            }
        }
    }
}

// MARK: - Setup Bindig
extension RouteFinderSheetViewController {
    private func setupBindings() {
        bindButtons()
        subscribeToPublishers()
    }
    
    private func bindButtons() {
        routeFinderSheetView.transportButtons.forEach { [weak self] button in
            let action = UIAction { [weak self] _ in self?.transportButtonTapped(button) }
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    private func subscribeToPublishers() {
        setupBindSelectedTransport()
        setupBindRoutes()
    }
    
    private func setupBindSelectedTransport() {
        viewModel.selectedTransport
            .receive(on: DispatchQueue.main)
            .compactMap{ $0}
            .sink { [weak self] transport in
                guard let self else { return }
                routeFinderSheetView.updateButtonStates(transport: transport)
                delegate?.requestRouteUpdate(sender: self, transportType: transport)
            }
            .store(in: &cancellables)
    }
    
    private func setupBindRoutes() {
        viewModel.routes
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routes in
                guard let self else { return }
                updateDetent()
                updateCellLayer(routes: routes)
                delegate?.didSelectRoute(sender: self, routes: routes)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Action
extension RouteFinderSheetViewController {
    private func transportButtonTapped(_ selectedButton: UIButton) {
        guard let identifier = selectedButton.accessibilityIdentifier,
              let transport = Transport(rawValue: identifier)
        else { return }
        viewModel.selectedTransport.send(transport)
    }
}

// MARK: - Configure
extension RouteFinderSheetViewController {
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
