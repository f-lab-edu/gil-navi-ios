//
//  UITextField+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/9/24.
//

import UIKit

extension UITextField {
    /**
     시스템 폰트를 사용하여 다이나믹 타입 폰트 적용
     - Parameters:
        - textStyle: 적용할 글꼴 스타일, 예: `.body`, `.headline`
        - size: 폰트 크기
        - weight: 폰트 무게
     */
    func applyDynamicTypeFont(
        textStyle: UIFont.TextStyle,
        size: CGFloat,
        weight: UIFont.Weight
    ) {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        self.font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
        adjustsFontForContentSizeCategory = true
    }
}
