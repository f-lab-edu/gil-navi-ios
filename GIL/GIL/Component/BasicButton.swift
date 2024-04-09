//
//  BasicButton.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class BasicButton: UIButton {
    static let enabledBackgroundColor = UIColor.mainGreenColor
    static let disabledBackgroundColor = UIColor.lightGray
    
    // MARK: - Initialization
    init(
        title: String,
        titleColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 18, weight: .bold),
        backgroundColor: UIColor? = BasicButton.enabledBackgroundColor
    ) {
        super.init(frame: .zero)
        
        configureUI(title: title,
                    titleColor: titleColor,
                    font: font,
                    backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure UI
extension BasicButton {
    func configureUI(
        title: String,
        titleColor: UIColor,
        font: UIFont,
        backgroundColor bgColor: UIColor?
    ) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        applyDynamicTypeFont(.body, font: font)
        backgroundColor = bgColor
        layer.cornerRadius = 6
    }
}

