//
//  RouteFinderView.swift
//  GIL
//
//  Created by 송우진 on 5/11/24.
//

import UIKit

final class RouteFinderView: UIView {
    let pathTitleLabel = UILabel()
    let transportStackView = BaseStackView(axis: .horizontal, spacing: 6)
    lazy var transportButtons: [UIButton] = [Transport.walking, Transport.automobile].map({ createTransportButton($0) })
    lazy var routeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: RouteCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
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
extension RouteFinderView {
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [pathTitleLabel, transportStackView, routeCollectionView].forEach({ addSubview($0) })
        transportButtons.forEach({ transportStackView.addArrangedSubview($0) })
    }
    
    private func setupComponents() {
        setupTitleLabel()
        setupTransportButtons()
        setupRouteCollectionView()
    }
    
    private func setupTitleLabel() {
        pathTitleLabel
            .setIsAccessibilityElement(false)
            .setText(text: "경로")
            .setTextColor(textColor: .lightBlackDarkWhite)
            .setFont(textStyle: .title1, size: 24, weight: .bold)
            .top(equalTo: topAnchor, constant: 20)
            .left(equalTo: leadingAnchor, constant: 20)
    }
    
    private func setupTransportButtons() {
        transportStackView
            .top(equalTo: pathTitleLabel.bottomAnchor, constant: 14)
            .left(equalTo: pathTitleLabel.leadingAnchor)
            .right(equalTo: trailingAnchor, constant: -16)
            .height(34)
    }
    
    private func setupRouteCollectionView() {
        routeCollectionView
            .setBackgroundColor(.systemBackground)
            .top(equalTo: transportStackView.bottomAnchor, constant: 14)
            .left(equalTo: transportStackView.leadingAnchor)
            .right(equalTo: transportStackView.trailingAnchor)
            .bottom(equalTo: bottomAnchor, constant: -10)
    }
}

// MARK: - Create View
extension RouteFinderView {
    private func createTransportButton(_ type: Transport) -> UIButton {
        UIButton()
            .setAccessibilityIdentifier(type.rawValue)
            .setAccessibility(label: "이동 수단 \(type.rawValue) 버튼", hint: "해당 이동 수단을 선택하려면 두 번 탭하세요", traits: .button)
            .setSysyemImage(name: type.systemImageName)
            .setTintColor(.gray)
            .setBackgroundColor(.systemGray6, for: .normal)
            .setBackgroundColor(.systemBlue, for: .selected)
            .setLayer(cornerRadius: 4)
    }
}

// MARK: - Update UI
extension RouteFinderView {
    func updateButtonStates(transport: Transport) {
        transportButtons.forEach {
            $0.isSelected = ($0.accessibilityIdentifier == transport.rawValue)
            $0.setTintColor($0.isSelected ? .white : .gray)
        }
    }
}
