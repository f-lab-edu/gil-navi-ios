//
//  PlaceSearchNavigationBar.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit

final class PlaceSearchNavigationBar: UIView {
    private let myLocationLabel = BaseLabel(text: "내 위치".localized(), fontSize: 11, fontWeight: .regular)
    private let addressLabel = BaseLabel(text: "", textColor: .lightBlackDarkWhite, fontSize: 13, fontWeight: .bold)
    let backButton = UIButton()
    let searchBar = UISearchBar()
    
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
extension PlaceSearchNavigationBar {
    private func setupUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupComponents()
    }
    
    private func addSubviews() {
        [backButton, myLocationLabel, addressLabel, searchBar].forEach({ addSubview($0) })
    }
    
    private func setupComponents() {
        setupBackButton()
        setupSearchBar()
        setupMyLocationLabel()
        setupAddressLabel()
    }
    
    private func setupBackButton() {
        backButton
            .setAccessibilityIdentifier("PlaceSearchNavigationBarBackButton")
            .setAccessibility(label: "뒤로가기 버튼", hint: "장소 검색 화면을 닫으려면 두 번 탭하세요", traits: .button)
            .configureNavigationStyle(type: .back)
            .top(equalTo: topAnchor)
            .left(equalTo: leadingAnchor, constant: 11)
            .size(CGSize(width: 36, height: 30))
    }
    
    private func setupSearchBar() {
        searchBar.searchTextField.setBorderStyle(style: .none)
        searchBar
            .setAccessibility(label: "검색 필드", hint: "찾고자 하는 장소를 입력하세요", traits: .searchField)
            .setBackgroundColor(.gray)
            .setLayer(cornerRadius: 4, borderColor: .lightGray, borderWidth: 1)
            .top(equalTo: backButton.bottomAnchor, constant: 10)
            .left(equalTo: leadingAnchor, constant: 16)
            .right(equalTo: trailingAnchor, constant: -16)
            .height(40)
    }
    
    private func setupMyLocationLabel() {
        myLocationLabel
            .setIsAccessibilityElement(false)
            .top(equalTo: topAnchor)
            .left(equalTo: backButton.trailingAnchor, constant: 8)
    }
    
    private func setupAddressLabel() {
        addressLabel
            .setAccessibility(label: "주소 레이블", hint: "현재 위치의 주소를 표시합니다")
            .top(equalTo: myLocationLabel.bottomAnchor)
            .left(equalTo: myLocationLabel.leadingAnchor)
            .right(equalTo: trailingAnchor, constant: -11)
    }
}

// MARK: - UI Update
extension PlaceSearchNavigationBar {
    func updateAddress(_ address: String) {
        addressLabel.text = address
        
    }
}

// MARK: - Accessibility
extension PlaceSearchNavigationBar {
    func postAccessibilityUpdateAddress(_ address: String) {
        UIAccessibility.post(notification: .announcement, argument: "현재 위치가 \(address)로 변경되었습니다")
    }
}
