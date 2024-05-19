//
//  RecentSearchPlaceButton.swift
//  GIL
//
//  Created by 송우진 on 5/16/24.
//

import UIKit

final class RecentSearchPlaceButton: UIButton {
    private let iconImageView: UIImageView = MappinImageView(iconType: .filled)
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let borderView = UIView()
    private var place: PlaceData
    
    // MARK: - Initialization
    init(place: PlaceData) {
        self.place = place
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup and Configuration
extension RecentSearchPlaceButton {
    private func configure() {
        setBackgroundColor(.systemBackground)
        setupAccessibility()
        setupButton()
    }
    
    private func setupAccessibility() {
        let name = place.place.name
        let address = place.place.placemark.address ?? "알 수 없음"
        let hint = "장소 이름은 \(name) 장소의 주소는 \(address)입니다. 해당 장소로 길을 찾으려면 두 번 탭하세요"
        setAccessibility(label: "최근 검색 장소 버튼", hint: hint, traits: .button)
    }
    
    private func setupButton() {
        [iconImageView, nameLabel, addressLabel, borderView].forEach { addSubview($0) }
        setupIconImageView()
        setupNameLabel()
        setupAddressLabel()
        setupBorderView()
    }
    
    private func setupIconImageView() {
        iconImageView.makeConstraints ({
            $0.leading(equalTo: leadingAnchor, constant: 26)
            $0.centerY(equalTo: centerYAnchor)
            $0.size(CGSize(width: 30, height: 30))
        })
    }
        
    private func setupNameLabel() {
        nameLabel
            .setText(text: place.place.name)
            .setTextColor(textColor: .mainText)
            .setFont(textStyle: .body, size: 15, weight: .bold)
            .makeConstraints({
                $0.leading(equalTo: iconImageView.trailingAnchor, constant: 10)
                $0.trailing(equalTo: trailingAnchor, constant: 26)
                $0.top(equalTo: topAnchor, constant: 10)
            })
    }
    
    private func setupAddressLabel() {
        addressLabel
            .setText(text: place.place.placemark.address ?? "")
            .setTextColor(textColor: .mainText)
            .setFont(textStyle: .body, size: 13, weight: .medium)
            .makeConstraints ({
                $0.top(equalTo: nameLabel.bottomAnchor, constant: 5)
                $0.bottom(equalTo: bottomAnchor, constant: 10)
                $0.matchParent(nameLabel, attributes: [.leading, .trailing])
            })
    }
    
    private func setupBorderView() {
        borderView
            .setBackgroundColor(.lightGray)
            .makeConstraints ({
                $0.bottom(equalTo: bottomAnchor)
                $0.matchParent(self, attributes: [.leading, .trailing], insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
                $0.height(equalToConstant: 1)
            })
    }
}
