//
//  BaseLabel.swift
//  GIL
//
//  Created by 송우진 on 4/21/24.
//

import UIKit

final class BaseLabel: UILabel {
    // MARK: - Initialization
    init(
        text: String,
        textColor: UIColor = .mainText,
        fontType: UIFont.TextStyle = .body,
        fontSize: CGFloat = 14,
        fontWeight: UIFont.Weight = .medium,
        numberOfLines: Int = 1
    ) {
        super.init(frame: .zero)
        configureUI(text: text,
                    textColor: textColor,
                    fontType: fontType,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    numberOfLines: numberOfLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configureUI(
        text txt: String,
        textColor txtColor: UIColor,
        fontType: UIFont.TextStyle,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight,
        numberOfLines lines: Int
    ) {
        text = txt.localized()
        textColor = txtColor
        numberOfLines = lines
        setFont(textStyle: fontType, size: fontSize, weight: fontWeight)
    }
}
