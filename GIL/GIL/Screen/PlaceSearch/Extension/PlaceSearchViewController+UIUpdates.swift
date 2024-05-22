//
//  PlaceSearchViewController+UIUpdates.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

extension PlaceSearchViewController {
    func applySnapshot(with items: [Place]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .main))
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
