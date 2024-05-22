//
//  HomeRecentSearchPlaceCollectionViewCell.swift
//  GIL
//
//  Created by 송우진 on 4/30/24.
//

import UIKit

final class HomeRecentSearchPlaceCollectionViewCell: UICollectionViewCell, CollectionViewCellProtocol {
    static let reuseIdentifier = String(describing: HomeRecentSearchPlaceCollectionViewCell.self)
    private let stackView = UIStackView()
    var onplaceButtonTapped: ((Place) -> Void)?
    
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
extension HomeRecentSearchPlaceCollectionViewCell {
    private func setupUI() {
        addSubviews()
        setupSearchBarView()
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    private func setupSearchBarView() {
        stackView
            .setAxis(.vertical)
            .setSpacing(10)
            .setDistribution(.fillEqually)
            .setAlignment(.fill)
            .makeConstraints({
                $0.matchParent(contentView, attributes: [.top, .bottom, .leading, .trailing])
            })
    }
}

// MARK: - Action
extension HomeRecentSearchPlaceCollectionViewCell {
    func placeButtonTapped(data: Place) {
        onplaceButtonTapped?(data)
    }
}

// MARK: - Configure Cell
extension HomeRecentSearchPlaceCollectionViewCell {
    func configure(with places: [Place]) {
        cleanup()
        configureButtons(with: places)
    }
    
    private func cleanup() {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func configureButtons(with places: [Place]) {
        for place in places {
            let button = RecentSearchPlaceButton(place: place)
            button.addAction(UIAction { [weak self] _ in self?.placeButtonTapped(data: place)}, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Cell Layout
extension HomeRecentSearchPlaceCollectionViewCell {
    static func layoutItem(count recentSearchCount: Int) -> NSCollectionLayoutItem {
        let recentSearchItemHeight = CGFloat(50 * recentSearchCount)
        let recentSearchItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(recentSearchItemHeight))
        return NSCollectionLayoutItem(layoutSize: recentSearchItemSize)
    }
}
