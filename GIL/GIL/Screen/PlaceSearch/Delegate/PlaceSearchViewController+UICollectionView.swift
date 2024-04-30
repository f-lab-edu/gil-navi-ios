//
//  PlaceSearchViewController+UICollectionView.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import UIKit

extension PlaceSearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let place = viewModel.mapItems[indexPath.row]
        viewModel.saveData(data: place)
    }
}
