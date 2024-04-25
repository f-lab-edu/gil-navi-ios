//
//  BasicLabel.swift
//  GIL
//
//  Created by 송우진 on 4/21/24.
//

import UIKit

final class BasicLabel: UILabel {
    // MARK: - Initialization
    init(
        text: String,
        textColor: UIColor = .text,
        fontSize: CGFloat = 14,
        fontWeight: UIFont.Weight = .medium
    ) {
        super.init(frame: .zero)
        configureUI(text: text,
                    textColor: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI
extension BasicLabel {
    func configureUI(
        text txt: String,
        textColor txtColor: UIColor,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight
    ) {
        text = txt.localized()
        textColor = txtColor
        applyDynamicTypeFont(textStyle: .body, size: fontSize, weight: fontWeight)   
    }
}
