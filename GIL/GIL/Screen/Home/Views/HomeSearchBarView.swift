//
//  HomeSearchBarView.swift
//  GIL
//
//  Created by 송우진 on 4/24/24.
//

import UIKit

final class HomeSearchBarView: UIView {
    private let searchIconImageView = UIImageView()
    private let searchLabel = UILabel()

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
            .setImage(UIImage(systemName: "magnifyingglass"))
            .setTintColor(.mainPlaceholder)
            .setContentMode(.scaleAspectFit)
            .left(equalTo: leadingAnchor, constant: 8)
            .centerY(equalTo: centerYAnchor)
            .size(CGSize(width: 24, height: 24))
    }
    
    private func setupSearchLabel() {
        searchLabel
            .setAccessibilityIdentifier("HomeSearchBarViewSearchLabel")
            .setAccessibility(label: "장소 검색 안내 레이블", hint: "장소 검색 화면으로 이동하려면 두 번 탭하세요")
            .setText(text: "어디로 갈까요?")
            .setFont(textStyle: .body, size: 14, weight: .regular)
            .left(equalTo: searchIconImageView.trailingAnchor, constant: 8)
            .right(equalTo: trailingAnchor, constant: -8)
            .centerY(equalTo: searchIconImageView.centerYAnchor)
    }
}
