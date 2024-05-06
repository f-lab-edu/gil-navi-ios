//
//  PlaceSearchCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import UIKit

class PlaceSearchCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseIdentifier = "PlaceSearchCell"
    private let mappinIcon = MappinImageView(iconType: .outline)
    private let stackView = BaseStackView(distribution: .equalCentering,spacing: 5)
    private let nameLabel = BaseLabel(text: "", fontSize: 15, fontWeight: .bold)
    private let addressLabel = BaseLabel(text: "", textColor: .grayLabel, fontSize: 13, fontWeight: .medium, numberOfLines: 0)
    
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
        contentView.addBorder(at: .bottom)
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [mappinIcon, stackView].forEach({ contentView.addSubview($0) })
        [nameLabel, addressLabel].forEach({ stackView.addArrangedSubview($0) })
    }
    
    private func setupComponents() {
        setupMappinIcon()
        setupStackView()
    }
    
    private func setupMappinIcon() {
        mappinIcon
            .size(CGSize(width: 30, height: 30))
            .applyConstraints(to: contentView, attributes: [.centerY, .leading])
    }
    
    private func setupStackView() {
        stackView
            .centerY(equalTo: mappinIcon.centerYAnchor)
            .left(equalTo: mappinIcon.trailingAnchor, constant: 11)
            .right(equalTo: contentView.trailingAnchor, constant: -11)
    }
}

// MARK: - Update Content
extension PlaceSearchCollectionViewCell {
    func updateContent(with item: Place) {
        let viewModel = PlaceSearchViewModel()
        nameLabel.text = item.name
        addressLabel.text = viewModel.getAddressForPlace(item)
    }
}
