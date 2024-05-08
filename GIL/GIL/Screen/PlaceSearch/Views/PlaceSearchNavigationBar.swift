//
//  PlaceSearchNavigationBar.swift
//  GIL
//
//  Created by 송우진 on 4/28/24.
//

import UIKit

final class PlaceSearchNavigationBar: UIView {
    let backButton = NavigationActionButton(type: .back)
    let myLocationLabel = BaseLabel(text: "내 위치".localized(), fontSize: 11, fontWeight: .regular)
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
    
    // MARK: - Drawing Cycle
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
}

// MARK: - Setup UI
extension PlaceSearchNavigationBar {
    private func setupUI() {
        setupSearchBar()

        [backButton, myLocationLabel, addressLabel, searchBar].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupSearchBar() {
        searchBar.backgroundColor = .gray
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 4
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.layer.borderWidth = 1
        searchBar.searchTextField.borderStyle = .none
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            myLocationLabel.topAnchor.constraint(equalTo: topAnchor),
            myLocationLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            
            addressLabel.topAnchor.constraint(equalTo: myLocationLabel.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: myLocationLabel.leadingAnchor),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -11),
            
            searchBar.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
