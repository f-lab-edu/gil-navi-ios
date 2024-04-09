//
//  UILabel+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/9/24.
//

import UIKit

extension UILabel {
    /**
     다이나믹 타입 폰트 적용
     - Parameters:
        - textStyle: 적용할 글꼴 스타일. 예: `.body`, `.headlin`
        - font: 적용할 폰트
     */
    func applyDynamicTypeFont(
        _ textStyle: UIFont.TextStyle,
        font: UIFont
    ) {
        self.font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
        adjustsFontForContentSizeCategory = true
    }
}
