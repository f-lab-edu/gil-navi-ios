//
//  BasicButton.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class BasicButton: UIButton {
    static let enabledBackgroundColor = UIColor.mainGreen
    static let disabledBackgroundColor = UIColor.lightGray
    
    // MARK: - Initialization
    init(
        title: String,
        titleColor: UIColor = .white,
        fontSize: CGFloat = 18,
        fontWeight: UIFont.Weight = .bold,
        backgroundColor: UIColor? = BasicButton.enabledBackgroundColor
    ) {
        super.init(frame: .zero)
        
        configureUI(title: title,
                    titleColor: titleColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
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
        fontSize: CGFloat,
        fontWeight: UIFont.Weight,
        backgroundColor bgColor: UIColor?
    ) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        applyDynamicTypeFont(textStyle: .body, size: fontSize, weight: fontWeight)
        backgroundColor = bgColor
        layer.cornerRadius = 6
    }
}

