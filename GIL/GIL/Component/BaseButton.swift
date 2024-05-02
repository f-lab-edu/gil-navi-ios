//
//  BaseButton.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import UIKit

class BaseButton: UIButton {
    // MARK: - Initializers
    init(
        title: String? = nil,
        titleState: UIControl.State = .normal,
        titleColor: UIColor? = nil,
        titleColorState: UIControl.State = .normal,
        fontType: UIFont.TextStyle = .body,
        fontSize: CGFloat = 15,
        fontWeight: UIFont.Weight = .medium,
        bgNormal backgroundImageNormal: UIImage? = nil,
        bgHighlighted backgroundImageHighlighted: UIImage? = nil
    ) {
        super.init(frame: .zero)
        configure(title: title, titleState: titleState, titleColor: titleColor, titleColorState: titleColorState, fontType: fontType, fontSize: fontSize, fontWeight: fontWeight, backgroundImageNormal: backgroundImageNormal, backgroundImageHighlighted: backgroundImageHighlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configure(
        title: String?,
        titleState: UIControl.State,
        titleColor: UIColor?,
        titleColorState: UIControl.State,
        fontType: UIFont.TextStyle,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight,
        backgroundImageNormal: UIImage?,
        backgroundImageHighlighted: UIImage?
    ) {
        clipsToBounds = true
        setTitle(title?.localized(), for: state)
        setTitleColor(titleColor, for: titleColorState)
        applyDynamicTypeFont(textStyle: fontType, size: fontSize, weight: fontWeight)
        if let bgImageNormal = backgroundImageNormal {
            setBackgroundImage(bgImageNormal, for: .normal)
        }
        if let bgImageHighlighted = backgroundImageHighlighted {
            setBackgroundImage(bgImageHighlighted, for: .highlighted)
        }
    }
}
