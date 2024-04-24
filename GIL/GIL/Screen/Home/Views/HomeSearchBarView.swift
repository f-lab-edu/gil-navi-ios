//
//  HomeSearchBarView.swift
//  GIL
//
//  Created by 송우진 on 4/24/24.
//

import UIKit

final class HomeSearchBarView: UIView {
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "어디로 갈까요?".localized()
        label.textColor = .placeholder
        label.applyDynamicTypeFont(textStyle: .body, size: 15, weight: .regular)
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    // MARK: - Drawing Cycle
    override func updateConstraints() {
        setConstraints()
        super.updateConstraints()
    }
}

// MARK: - Configure UI
extension HomeSearchBarView {
    func configureUI() {
        layer.cornerRadius = 3
        backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        clipsToBounds = false
        
        [searchIconImageView, searchLabel, favoriteButton].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            searchIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIconImageView.widthAnchor.constraint(equalToConstant: 24),
            searchIconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            searchLabel.leadingAnchor.constraint(equalTo: searchIconImageView.trailingAnchor, constant: 8),
            searchLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            searchLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            searchLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
