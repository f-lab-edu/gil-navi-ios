//
//  PlaceSearchViewController.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit
import CoreLocation
import MapKit

final class PlaceSearchViewController: BaseViewController, NavigationBarHideable {
    enum Section: CaseIterable {
        case main
    }
    
    var viewModel: PlaceSearchViewModel
    var placeSearchView = PlaceSearchView()
    var dataSource: UICollectionViewDiffableDataSource<Section, Place>!
    
    // MARK: - Initialization
    init(viewModel: PlaceSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = placeSearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
    }
}
