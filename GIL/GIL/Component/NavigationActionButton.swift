//
//  NavigationActionButton.swift
//  GIL
//
//  Created by 송우진 on 4/15/24.
//

import UIKit

final class NavigationActionButton: UIButton {

    enum ButtonType {
        case close
        case back
    }
    
    var btnType: ButtonType = .close
    
    // MARK: - Initialization
    init(type: ButtonType = .close) {
        btnType = type
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
extension NavigationActionButton {
    private func configureImage() {
        let tintColor: UIColor = (traitCollection.userInterfaceStyle == .dark) ? .white : .black
        
        var systemName: String
        var iconWidth: CGFloat
        
        switch btnType {
        case .close:
            iconWidth = 25
            systemName = "xmark"
        case .back:
            iconWidth = 17
            systemName = "chevron.backward"
        }
        
        let originalImage = UIImage(systemName: systemName)
        
        if let resizedImage = originalImage?.resized(toWidth: iconWidth) {
            setImage(resizedImage.withTintColor(tintColor), for: .normal)
        } else {
            setImage(originalImage?.withTintColor(tintColor), for: .normal)
        }
    }
}
