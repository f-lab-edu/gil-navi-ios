//
//  HomeSearchCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/24/24.
//

import UIKit

final class HomeSearchCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseIdentifier = "HomeSearchCell"
    private let searchBarView = HomeSearchBarView()
    var onSearchBarTapped: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBindTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Binding
extension HomeSearchCollectionViewCell {
    private func setupBindTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchBarTapped))
        searchBarView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Gestures
extension HomeSearchCollectionViewCell {
    @objc private func searchBarTapped() {
        onSearchBarTapped?()
    }
}

// MARK: - Setup UI
extension HomeSearchCollectionViewCell {
    private func setupUI() {
        addSubviews()
        setupSearchBarView()
    }
    
    private func addSubviews() {
        contentView.addSubview(searchBarView)
    }
    
    private func setupSearchBarView() {
        searchBarView
            .centerY(equalTo: contentView.centerYAnchor)
            .left(equalTo: contentView.leadingAnchor, constant: 10)
            .right(equalTo: contentView.trailingAnchor, constant: -10)
            .height(50)
    }
}

// MARK: - Cell Layout
extension HomeSearchCollectionViewCell {
    static func layoutItem() -> NSCollectionLayoutItem {
        let searchItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        return NSCollectionLayoutItem(layoutSize: searchItemSize)
    }
}
