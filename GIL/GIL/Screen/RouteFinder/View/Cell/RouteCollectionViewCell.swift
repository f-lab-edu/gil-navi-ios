//
//  RouteCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import UIKit

final class RouteCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static var reuseIdentifier: String = "RouteCell"
    let labelStackView = UIStackView()
    let expectedTimeLabel = UILabel()
    let distanceLabel = UILabel()
    let moveButton = UIButton()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func prepareForReuse() {
        super.prepareForReuse()
        updateLayer(selected: false)
    }
}

// MARK: - Setup UI
extension RouteCollectionViewCell {
    private func setupUI() {
        contentView
            .setBackgroundColor(.systemGray6)
            .setLayer(cornerRadius: 6)
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [labelStackView, moveButton].forEach({ contentView.addSubview($0) })
        [expectedTimeLabel, distanceLabel].forEach({ labelStackView.addArrangedSubview($0) })
    }
    
    private func setupComponents() {
        setupLabelStackView()
        setupExpectedTimeLabel()
        setupDistanceLabel()
        setupMoveButton()
    }
    
    private func setupLabelStackView() {
        labelStackView
            .setAxis(.vertical)
            .setSpacing(5)
            .left(equalTo: contentView.leadingAnchor, constant: 16)
            .centerY(equalTo: contentView.centerYAnchor)
    }
    
    private func setupExpectedTimeLabel() {
        expectedTimeLabel
            .setTextColor(textColor: .lightBlackDarkWhite)
            .setFont(textStyle: .body, size: 20, weight: .bold)
    }
    
    private func setupDistanceLabel() {
        distanceLabel
            .setTextColor(textColor: .systemGray2)
            .setFont(textStyle: .footnote, size: 14, weight: .medium)
    }
    
    private func setupMoveButton() {
        /// - Note: 기능 추가 후 노출
        moveButton
            .setIsHidden(true)
            .setTitle(title: "이동", state: .normal)
            .setTitleColor(color: .white, state: .normal)
            .setFont(textStyle: .body, size: 22, weight: .bold)
            .setBackgroundColor(.mainGreen, for: .normal)
            .setLayer(cornerRadius: 4)
            .right(equalTo: contentView.trailingAnchor, constant: -16)
            .centerY(equalTo: contentView.centerYAnchor)
            .size(CGSize(width: 50, height: 50))
    }
}

// MARK: - Update Content
extension RouteCollectionViewCell {
    func updateContent(with route: RouteModel) {
        let formattedTime = route.expectedTravelTime.toHourMinuteFormat()
        expectedTimeLabel.text = formattedTime
        
        let formattedDistance = route.distance.formattedDistanceDetailed()
        distanceLabel.text = formattedDistance
    }
    
    func updateLayer(selected: Bool) {
        contentView.setLayer(cornerRadius: 6, borderColor: .mainGreen, borderWidth: selected ? 2 : 0)
    }
}

// MARK: - Cell Layout
extension RouteCollectionViewCell {
    static func layoutItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}
