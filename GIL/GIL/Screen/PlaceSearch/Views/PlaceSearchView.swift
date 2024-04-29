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
    
    // MARK: - Drawing Cycle
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
}

// MARK: - Setup UI
extension PlaceSearchView {
    func setupUI() {
        backgroundColor = .systemBackground

        [navigationBar, searchResultsCollectionView].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 80),
            
            searchResultsCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
