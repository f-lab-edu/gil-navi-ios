//
//  HomeRecentSearchPlaceCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import UIKit

final class HomeRecentSearchPlaceCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseIdentifier = "HomeRecentSearchPlaceCell"
    private let stackView = BaseStackView(spacing: 10)
    private var buttons: [UIButton] = []
    var onplaceButtonTapped: ((PlaceData) -> Void)?
    
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
extension HomeRecentSearchPlaceCollectionViewCell {
    private func setupUI() {
        addSubviews()
        setupSearchBarView()
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    private func setupSearchBarView() {
        stackView.applyConstraints(to: contentView, attributes: [.top, .bottom, .leading, .trailing])
    }
}

// MARK: - Action
extension HomeRecentSearchPlaceCollectionViewCell {
    func placeButtonTapped(data: PlaceData) {
        onplaceButtonTapped?(data)
    }
}

// MARK: - Configure Cell
extension HomeRecentSearchPlaceCollectionViewCell {
    func configure(with places: [PlaceData]) {
        cleanup()
        configureButtons(with: places)
    }
    
    private func cleanup() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
    }
    
    private func configureButtons(with places: [PlaceData]) {
        for place in places {
            let button = createButton(for: place)
            stackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Button Creation and Layout
extension HomeRecentSearchPlaceCollectionViewCell {
    private func createButton(for place: PlaceData) -> UIButton {
        let iconImageView = MappinImageView(iconType: .filled)
        let nameLabel = BaseLabel(text: place.place.name, fontSize: 15, fontWeight: .bold)
        let addressLabel = BaseLabel(text: place.place.placemark.address ?? "", fontSize: 13, fontWeight: .medium)
        let border = UIView().setBackgroundColor(.lightGray)
        
        let button = UIButton().setBackgroundColor(.systemBackground)
        button.addAction(UIAction { _ in self.placeButtonTapped(data: place)}, for: .touchUpInside)
        [iconImageView, nameLabel, addressLabel, border].forEach({ button.addSubview($0) })
        setupButtonLayout(button: button, icon: iconImageView, name: nameLabel, address: addressLabel, border: border)
        setupAccessibility(button: button, placeName: nameLabel.text ?? "장소 이름 없음", placeAddress: addressLabel.text ?? "장소 주소 없음")
        return button
    }
    
    private func setupAccessibility(
        button: UIButton,
        placeName: String,
        placeAddress: String
    ) {
        button
            .setAccessibilityLabel("최근 검색 장소입니다. 장소 이름: \(placeName), 장소 주소: \(placeAddress)")
            .setAccessibilityHint("해당 장소로 길을 찾으려면 두 번 탭하세요")
            .setAccessibilityTraits(.button)
    }
    
    private func setupButtonLayout(
        button: UIButton,
        icon: UIImageView,
        name: UILabel,
        address: UILabel,
        border: UIView
    ) {
        icon
            .left(equalTo: button.leadingAnchor, constant: 26)
            .centerY(equalTo: button.centerYAnchor)
            .size(CGSize(width: 30, height: 30))
        name
            .left(equalTo: icon.trailingAnchor, constant: 10)
            .right(equalTo: button.trailingAnchor, constant: -26)
            .top(equalTo: button.topAnchor, constant: 10)
        address
            .top(equalTo: name.bottomAnchor, constant: 5)
            .bottom(equalTo: button.bottomAnchor, constant: -10)
            .applyConstraints(to: name, attributes: [.leading, .trailing])
        border
            .bottom(equalTo: button.bottomAnchor)
            .left(equalTo: button.leadingAnchor, constant: 20)
            .right(equalTo: button.trailingAnchor, constant: -20)
            .height(1)
    }
}

// MARK: - Cell Layout
extension HomeRecentSearchPlaceCollectionViewCell {
    static func layoutItem(count recentSearchCount: Int) -> NSCollectionLayoutItem {
        let recentSearchItemHeight = CGFloat(50 * recentSearchCount)
        let recentSearchItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(recentSearchItemHeight))
        return NSCollectionLayoutItem(layoutSize: recentSearchItemSize)
    }
}
