//
//  RouteFinderSheetCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import UIKit

final class RouteFinderSheetCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static var reuseIdentifier: String = String(describing: RouteFinderSheetCollectionViewCell.self)
    private let labelStackView = UIStackView()
    private let expectedTimeLabel = UILabel()
    private let distanceLabel = UILabel()
    private let moveButton = UIButton()
    
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
extension RouteFinderSheetCollectionViewCell {
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
            .makeConstraints({
                $0.leading(equalTo: contentView.leadingAnchor, constant: 16)
                $0.centerY(equalTo: contentView.centerYAnchor)
            })
    }
    
    private func setupExpectedTimeLabel() {
        expectedTimeLabel
            .setAccessibilityHint("목적지까지 걸리는 시간입니다. 해당 경로를 선택하려면 두 번 탭하세요")
            .setTextColor(textColor: .lightBlackDarkWhite)
            .setFont(textStyle: .body, size: 20, weight: .bold)
    }
    
    private func setupDistanceLabel() {
        distanceLabel
            .setAccessibilityHint("목적지까지의 거리입니다. 해당 경로를 선택하려면 두 번 탭하세요")
            .setTextColor(textColor: .systemGray2)
            .setFont(textStyle: .footnote, size: 14, weight: .medium)
    }
    
    private func setupMoveButton() {
        /// - Note: 기능 추가 후 노출
        moveButton
            .setIsAccessibilityElement(false)
            .setIsHidden(true)
            .setTitle(title: "이동", state: .normal)
            .setTitleColor(color: .white, state: .normal)
            .setFont(textStyle: .body, size: 22, weight: .bold)
            .setBackgroundColor(.mainGreen, for: .normal)
            .setLayer(cornerRadius: 4)
            .makeConstraints({
                $0.trailing(equalTo: contentView.trailingAnchor, constant: 16)
                $0.centerY(equalTo: contentView.centerYAnchor)
                $0.size(CGSize(width: 50, height: 50))
            })
    }
}

// MARK: - Update Content
extension RouteFinderSheetCollectionViewCell {
    func updateContent(with route: Route) {
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
extension RouteFinderSheetCollectionViewCell {
    static func layoutItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}
