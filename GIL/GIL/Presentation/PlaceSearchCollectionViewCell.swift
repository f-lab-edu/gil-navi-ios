//
//  PlaceSearchCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import UIKit

final class PlaceSearchCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseIdentifier = String(describing: PlaceSearchCollectionViewCell.self)
    private let mappinIcon = MappinImageView(iconType: .outline)
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    
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
extension PlaceSearchCollectionViewCell {
    private func setupUI() {
        contentView.applyBorder(at: .bottom)
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [mappinIcon, stackView].forEach({ contentView.addSubview($0) })
        [nameLabel, addressLabel].forEach({ stackView.addArrangedSubview($0) })
    }
    
    private func setupComponents() {
        setupMappinIcon()
        setupNameLabel()
        setupAddressLabel()
        setupStackView()
    }
    
    private func setupMappinIcon() {
        mappinIcon
            .setIsAccessibilityElement(false)
            .makeConstraints({
                $0.size(CGSize(width: 30, height: 30))
                $0.matchParent(contentView, attributes: [.centerY, .leading])
            })
    }
    
    private func setupStackView() {
        stackView
            .setAxis(.vertical)
            .setDistribution(.equalCentering)
            .setSpacing(5)
            .makeConstraints({
                $0.centerY(equalTo: mappinIcon.centerYAnchor)
                $0.leading(equalTo: mappinIcon.trailingAnchor, constant: 11)
                $0.trailing(equalTo: contentView.trailingAnchor, constant: 11)
            })
    }
    
    private func setupNameLabel() {
        nameLabel
            .setAccessibilityHint("해당 장소로 길을 찾으려면 두 번 탭하세요")
            .setTextColor(textColor: .mainText)
            .setFont(textStyle: .body, size: 15, weight: .bold)
    }
    
    private func setupAddressLabel() {
        addressLabel
            .setAccessibilityHint("해당 장소로 길을 찾으려면 두 번 탭하세요")
            .setTextColor(textColor: .lightGray)
            .setFont(textStyle: .body, size: 13, weight: .medium)
            .setNumberOfLines(lineCount: 0)
    }
}

// MARK: - Update Content
extension PlaceSearchCollectionViewCell {
    func updateContent(with item: MapItem) {
        nameLabel.text = item.name
        addressLabel.text = item.formatAddressWithDistance()
    }
}

// MARK: - Cell Layout
extension PlaceSearchCollectionViewCell {
    static func layoutItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}
