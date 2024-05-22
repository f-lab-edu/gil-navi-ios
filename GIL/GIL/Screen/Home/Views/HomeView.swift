//
//  HomeView.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit

final class HomeView: UIView {
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(HomeSearchCollectionViewCell.self, forCellWithReuseIdentifier: HomeSearchCollectionViewCell.reuseIdentifier)
        collectionView.register(HomeRecentSearchPlaceCollectionViewCell.self, forCellWithReuseIdentifier: HomeRecentSearchPlaceCollectionViewCell.reuseIdentifier)
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
extension HomeView {
    private func setupUI() {
        addSubviews()
        setupMainCollectionView()
    }
    
    private func addSubviews() {
        addSubview(mainCollectionView)
    }
    
    private func setupMainCollectionView() {
        mainCollectionView.applyConstraints(to: self, attributes: [.top, .bottom, .leading, .trailing])
    }
}
