//
//  HomeSearchCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/24/24.
//

import UIKit

class HomeSearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeSearchCell"
    let searchBarView = HomeSearchBarView()
    var onSearchBarTapped: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupBindings()
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

// MARK: - Binding
extension HomeSearchCollectionViewCell {
    func setupBindings() {
        bindTapGesture()
    }
    
    private func bindTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchBarTapped))
        searchBarView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Gestures
extension HomeSearchCollectionViewCell {
    @objc func searchBarTapped() {
        onSearchBarTapped?()
    }
}

// MARK: - Configure UI
extension HomeSearchCollectionViewCell {
    func configureUI() {
        contentView.addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        
        setNeedsUpdateConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            searchBarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchBarView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            searchBarView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            searchBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
