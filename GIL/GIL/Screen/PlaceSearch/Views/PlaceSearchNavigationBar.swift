//
//  PlaceSearchNavigationBar.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit

final class PlaceSearchNavigationBar: UIView {
    private let myLocationLabel = BaseLabel(text: "내 위치".localized(), fontSize: 11, fontWeight: .regular)
    let backButton = NavigationActionButton(type: .back)
    let addressLabel = BaseLabel(text: "", textColor: .blackLabel, fontSize: 13, fontWeight: .bold)
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
            .top(equalTo: topAnchor)
            .left(equalTo: leadingAnchor, constant: 11)
            .size(CGSize(width: 36, height: 30))
    }
    
    private func setupSearchBar() {
        searchBar.backgroundColor = .gray
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 4
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.searchTextField.borderStyle = .none
        searchBar
            .top(equalTo: backButton.bottomAnchor, constant: 10)
            .left(equalTo: leadingAnchor, constant: 16)
            .right(equalTo: trailingAnchor, constant: -16)
            .height(40)
    }
    
    private func setupMyLocationLabel() {
        myLocationLabel
            .top(equalTo: topAnchor)
            .left(equalTo: backButton.trailingAnchor, constant: 8)
    }
    
    private func setupAddressLabel() {
        addressLabel
            .top(equalTo: myLocationLabel.bottomAnchor)
            .left(equalTo: myLocationLabel.leadingAnchor)
            .right(equalTo: trailingAnchor, constant: -11)
    }
}

