//
//  PlaceSearchCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import UIKit

class PlaceSearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PlaceSearchCell"
    private let mappinIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .mainGreen
        return imageView
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    let nameLabel = BasicLabel(text: "", fontSize: 15, fontWeight: .bold)
    let addressLabel = BasicLabel(text: "", textColor: .grayLabel, fontSize: 13, fontWeight: .medium, numberOfLines: 0)
    
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
extension PlaceSearchCollectionViewCell {
    func setupUI() {
        contentView.addBorder(at: .bottom)
        
        [mappinIcon, stackView].forEach({
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [nameLabel, addressLabel].forEach({
            stackView.addArrangedSubview($0)
        })
        
        setNeedsUpdateConstraints()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mappinIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mappinIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mappinIcon.widthAnchor.constraint(equalToConstant: 30),
            mappinIcon.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.centerYAnchor.constraint(equalTo: mappinIcon.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: mappinIcon.trailingAnchor, constant: 11),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -11)
        ])
    }
}

// MARK: - Update Content
extension PlaceSearchCollectionViewCell {
    func updateContent(with item: Place) {
        nameLabel.text = item.name
        
        if let distance = item.distance {
            let formattedDistance = formatDistance(distance)
            addressLabel.text = "\(formattedDistance) · \(item.address ?? "")"
        } else {
            addressLabel.text = item.address
        }
    }

    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return "\(Int(distance))m"
        } else {
            return String(format: "%.2fkm", distance / 1000)
        }
    }
}
