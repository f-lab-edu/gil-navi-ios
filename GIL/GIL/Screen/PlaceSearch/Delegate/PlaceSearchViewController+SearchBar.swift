//
//  PlaceSearchViewController+SearchBar.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import UIKit

extension PlaceSearchViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        viewModel.searchPlace(searchText)
    }
}
