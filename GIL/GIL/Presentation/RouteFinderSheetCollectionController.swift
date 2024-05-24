//
//  RouteFinderSheetCollectionController.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import UIKit

final class RouteFinderSheetCollectionController: NSObject {
    private enum Section: CaseIterable {
        case main
    }
    private var routeFinderSheetView: RouteFinderSheetView
    private var viewModel: RouteFinderSheetViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Route>!
    
    // MARK: - Initialization
    init(
        viewModel: RouteFinderSheetViewModel,
        routeFinderSheetView: RouteFinderSheetView
    ) {
        self.viewModel = viewModel
        self.routeFinderSheetView = routeFinderSheetView
        super.init()
        setupCollectionView()
        configureDataSource()
    }
}

// MARK: - UICollectionViewDelegate {
extension RouteFinderSheetCollectionController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let snapshot = dataSource.snapshot()
        guard snapshot.sectionIdentifiers.contains(.main) else { return }
        let itemsInSection = snapshot.itemIdentifiers(inSection: .main)
        guard itemsInSection.indices.contains(indexPath.row) else { return }
        viewModel.updateRoutes(selectedRoute: itemsInSection[indexPath.row])
    }
}

// MARK: - DataSource Updates
extension RouteFinderSheetCollectionController {
    func applySnapshot(with items: [Route]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .main))
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Setup and Configuration
extension RouteFinderSheetCollectionController {
    private func setupCollectionView() {
        routeFinderSheetView.routeCollectionView.delegate = self
        routeFinderSheetView.routeCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let placeItem = RouteFinderSheetCollectionViewCell.layoutItem()
        let group = NSCollectionLayoutGroup.vertical(layoutSize: placeItem.layoutSize, subitems: [placeItem])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Route>(collectionView: routeFinderSheetView.routeCollectionView) { (collectionView, indexPath, route) -> UICollectionViewCell? in
            self.configureRouteCell(for: collectionView, at: indexPath, item: route)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Route>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Cell Configuration
extension RouteFinderSheetCollectionController {
    private func configureRouteCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        item: Route
    ) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteFinderSheetCollectionViewCell.reuseIdentifier, for: indexPath) as? RouteFinderSheetCollectionViewCell
        cell?.updateContent(with: item)
        return cell
    }
}

// MARK: - Cell Update
extension RouteFinderSheetCollectionController {
    func updateCellLayer(_ routes: [Route]) {
        let snapshot = dataSource.snapshot()
        guard snapshot.sectionIdentifiers.contains(.main) else { return }
        let itemsInSection = snapshot.itemIdentifiers(inSection: .main)
        for index in 0..<itemsInSection.count {
            if let cell = routeFinderSheetView.routeCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? RouteFinderSheetCollectionViewCell {
                let isSelected = routes[index].polyline.isSelected
                cell.updateLayer(selected: isSelected)
            }
        }
    }
}
