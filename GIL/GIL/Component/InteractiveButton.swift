//
//  InteractiveButton.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

final class InteractiveButton: BaseButton {
    static let enabledBackgroundColor = UIColor.mainGreen
    static let disabledBackgroundColor = UIColor.lightGray
    
    // MARK: - Initializers
    override init(
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
        super.init(title: title, titleState: titleState, titleColor: titleColor, titleColorState: titleColorState, fontType: fontType, fontSize: fontSize, fontWeight: fontWeight, bgNormal: backgroundImageNormal, bgHighlighted: backgroundImageHighlighted)
        
        backgroundColor = InteractiveButton.enabledBackgroundColor
        layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
