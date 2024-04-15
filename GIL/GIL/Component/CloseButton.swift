//
//  CloseButton.swift
//  GIL
//
//  Created by 송우진 on 4/15/24.
//

import UIKit

final class CloseButton: UIButton {

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        configureImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configureImage()
        }
    }
}

// MARK: - Configure
extension CloseButton {
    private func configureImage() {
        let tintColor: UIColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        let originalImage = UIImage(systemName: "xmark")
        if let resizedImage = originalImage?.resized(toWidth: 25) {
            setImage(resizedImage.withTintColor(tintColor), for: .normal)
        } else {
            setImage(originalImage?.withTintColor(tintColor), for: .normal)
        }
    }
}
