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
        setBackgroundColor(.white)
        setLayer(cornerRadius: 3)
        setShadow(color: .black, offset: CGSize(width: 0, height: 1), radius: 3, opacity: 0.2)
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
            .makeConstraints({
                $0.leading(equalTo: leadingAnchor, constant: 8)
                $0.centerY(equalTo: centerYAnchor)
                $0.size(CGSize(width: 24, height: 24))
            })
    }
    
    private func setupSearchLabel() {
        searchLabel
            .setAccessibility(label: "장소 검색 안내 레이블", hint: "장소 검색 화면으로 이동하려면 두 번 탭하세요")
            .setText(text: "어디로 갈까요?")
            .setFont(textStyle: .body, size: 14, weight: .regular)
            .makeConstraints({
                $0.leading(equalTo: searchIconImageView.trailingAnchor, constant: 8)
                $0.trailing(equalTo: trailingAnchor, constant: 8)
                $0.centerY(equalTo: searchIconImageView.centerYAnchor)
            })
    }
}
