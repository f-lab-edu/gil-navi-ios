//
//  PlaceSearchView.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit

final class PlaceSearchView: UIView {
    let navigationBar = PlaceSearchNavigationBar()
    lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PlaceSearchCollectionViewCell.self, forCellWithReuseIdentifier: PlaceSearchCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Setup UI
extension PlaceSearchView {
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [navigationBar, searchResultsCollectionView].forEach({ addSubview($0) })
    }
    
    private func setupComponents() {
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationBar
            .top(equalTo: safeAreaLayoutGuide.topAnchor)
            .height(80)
            .applyConstraints(to: self, attributes: [.leading, .trailing])
    }
    
    private func setupCollectionView() {
        searchResultsCollectionView
            .top(equalTo: navigationBar.bottomAnchor)
            .applyConstraints(to: self, attributes: [.leading, .trailing, .bottom])
    }
}
