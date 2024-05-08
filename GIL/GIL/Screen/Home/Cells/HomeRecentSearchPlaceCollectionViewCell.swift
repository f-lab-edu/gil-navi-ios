//
//  HomeRecentSearchPlaceCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import UIKit

class HomeRecentSearchPlaceCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseIdentifier = "HomeRecentSearchPlaceCell"
    private var buttons: [UIButton] = []
    
}

// MARK: - Configure Cell
extension HomeRecentSearchPlaceCollectionViewCell {
    func configure(with places: [PlaceData]) {
        cleanupButtons()
        configureButtons(with: places)
    }
    
    private func cleanupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
    }
    
    private func configureButtons(with places: [PlaceData]) {
        var previousButton: UIButton? = nil
        for place in places {
            let button = createButton(for: place)
            buttons.append(button)
            contentView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                button.topAnchor.constraint(equalTo: previousButton?.bottomAnchor ?? contentView.topAnchor, constant: 10)
            ])
            previousButton = button
            
            button.layoutIfNeeded()
            button.addBorder(at: .bottom, color: .lightGrayBorder)
        }
        if let lastButton = buttons.last {
            lastButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        }
    }
}


// MARK: - Button Creation and Layout
extension HomeRecentSearchPlaceCollectionViewCell {
    private func createButton(for place: PlaceData) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        
        let iconImageView = MappinImageView(iconType: .filled)
        let nameLabel = BaseLabel(text: place.place.name, fontSize: 15, fontWeight: .bold)
        let addressLabel = BaseLabel(text: place.place.address, fontSize: 13, fontWeight: .medium)
        
        [iconImageView, nameLabel, addressLabel].forEach({
            button.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        setupButtonLayout(button: button, icon: iconImageView, name: nameLabel, address: addressLabel)
        
        return button
    }
    
    private func setupButtonLayout(button: UIButton, icon: UIImageView, name: UILabel, address: UILabel) {
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            icon.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            name.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
            name.topAnchor.constraint(equalTo: button.topAnchor, constant: 10),
            
            address.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            address.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            address.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            address.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -10)
        ])
    }
}
