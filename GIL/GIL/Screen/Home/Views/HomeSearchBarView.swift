//
//  HomeSearchBarView.swift
//  GIL
//
//  Created by 송우진 on 4/24/24.
//

import UIKit

final class HomeSearchBarView: UIView {
    private let searchIconImageView = BaseImageView(image: UIImage(systemName: "magnifyingglass"), contentMode: .scaleAspectFit, tintColor: .mainPlaceholder)
    private let searchLabel = BaseLabel(text: "어디로 갈까요?", textColor: .mainPlaceholder, fontWeight: .regular)

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
extension HomeSearchBarView {
    private func setupUI() {
        setupView()
        addSubviews()
        setupComponents()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        clipsToBounds = false
    }
    
    private func addSubviews() {
        [searchIconImageView, searchLabel].forEach({ addSubview($0) })
    }

    private func setupComponents() {
        setupSearchIconImageView()
        setupSearchLabel()
    }
    
    private func setupSearchIconImageView() {
        searchIconImageView
            .left(equalTo: leadingAnchor, constant: 8)
            .centerY(equalTo: centerYAnchor)
            .size(CGSize(width: 24, height: 24))
    }
    
    private func setupSearchLabel() {
        searchLabel
            .left(equalTo: searchIconImageView.trailingAnchor, constant: 8)
            .right(equalTo: trailingAnchor, constant: -8)
            .centerY(equalTo: searchIconImageView.centerYAnchor)
    }
}
