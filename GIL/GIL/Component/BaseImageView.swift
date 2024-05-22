//
//  BaseImageView.swift
//  GIL
//
//  Created by 송우진 on 5/6/24.
//

import UIKit

class BaseImageView: UIImageView {
    
    // MARK: - Initialization
    init(
        image: UIImage?,
        contentMode: UIView.ContentMode = .scaleToFill,
        tintColor: UIColor? = nil
    ) {
        super.init(frame: .zero)
        configure(image: image, contentMode: contentMode, tintColor: tintColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func configure(
        image img: UIImage?,
        contentMode mode: UIView.ContentMode,
        tintColor color: UIColor?
    ) {
        image = img
        contentMode = mode
        tintColor = color
    }
}
