//
//  UITextField+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/9/24.
//

import UIKit

extension UITextField {
    /// TextField의 폰트를 설정합니다. 동적 타입을 지원하도록 UIFontMetrics를 사용합니다
    /// - Parameters:
    ///   - textStyle: 적용할 텍스트 스타일
    ///   - size: 폰트 크기
    ///   - weight: 폰트 무게
    @discardableResult
    func setFont(
        textStyle: UIFont.TextStyle,
        size: CGFloat,
        weight: UIFont.Weight
    ) -> Self {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: systemFont)
        adjustsFontForContentSizeCategory = true
        return self
    }
}
