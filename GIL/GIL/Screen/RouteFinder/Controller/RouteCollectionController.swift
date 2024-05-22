//
//  RouteCollectionController.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import UIKit

final class RouteCollectionController: NSObject {
    private enum Section: CaseIterable {
        case main
    }
    private var routeFinderView: RouteFinderView
    private var viewModel: RouteFinderViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, Route>!
    
    // MARK: - Initialization
    init(
        viewModel: RouteFinderViewModel,
        routeFinderView: RouteFinderView
    ) {
        self.viewModel = viewModel
        self.routeFinderView = routeFinderView
        super.init()
        setupCollectionView()
        configureDataSource()
    }
}

// MARK: - UICollectionViewDelegate {
extension RouteCollectionController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let snapshot = dataSource.snapshot()
        guard snapshot.sectionIdentifiers.contains(.main) else { return }
        let itemsInSection = snapshot.itemIdentifiers(inSection: .main)
        guard itemsInSection.indices.contains(indexPath.row) else { return }
        let route = itemsInSection[indexPath.row]
        viewModel.selectedRoute = route
    }
}

// MARK: - DataSource Updates
extension RouteCollectionController {
    func applySnapshot(with items: [Route]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .main))
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Setup and Configuration
extension RouteCollectionController {
    private func setupCollectionView() {
        routeFinderView.routeCollectionView.delegate = self
        routeFinderView.routeCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let placeItem = RouteCollectionViewCell.layoutItem()
        let group = NSCollectionLayoutGroup.vertical(layoutSize: placeItem.layoutSize, subitems: [placeItem])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Route>(collectionView: routeFinderView.routeCollectionView) { (collectionView, indexPath, route) -> UICollectionViewCell? in
            self.configureRouteCell(for: collectionView, at: indexPath, item: route)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, Route>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Cell Configuration
extension RouteCollectionController {
    private func configureRouteCell(
        for collectionView: UICollectionView,
        at indexPath: IndexPath,
        item: Route
    ) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteCollectionViewCell.reuseIdentifier, for: indexPath) as? RouteCollectionViewCell
        cell?.updateContent(with: item)
        return cell
    }
}

// MARK: - Cell Update
extension RouteCollectionController {
    func updateCellLayer(_ route: Route) {
        let snapshot = dataSource.snapshot()
        guard snapshot.sectionIdentifiers.contains(.main) else { return }
        let itemsInSection = snapshot.itemIdentifiers(inSection: .main)
        for index in 0..<itemsInSection.count {
            if let cell = routeFinderView.routeCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? RouteCollectionViewCell {
                let isSelected = itemsInSection[index] == route
                cell.updateLayer(selected: isSelected)
            }
        }
    }
}
