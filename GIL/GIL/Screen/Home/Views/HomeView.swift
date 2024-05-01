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
        configureUI()
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

// MARK: - Configure UI
extension HomeView {
    func configureUI() {
        [mainCollectionView].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainCollectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
