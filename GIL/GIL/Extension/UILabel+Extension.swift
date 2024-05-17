//
//  UILabel+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/9/24.
//

import UIKit

extension UILabel {
    /// Label의 텍스트을 설정합니다
    /// - Parameter text: 설정할 텍스트
    @discardableResult
    func setText(text txt: String) -> Self {
        text = txt.localized()
        return self
    }
    
    /// Label의 텍스트 컬러를 설정합니다
    /// - Parameter textColor: 설정할 텍스트 컬러
    @discardableResult
    func setTextColor(textColor color: UIColor) -> Self {
        textColor = color
        return self
    }
    
    /// Label의 라인 수를 설정합니다
    /// - Parameter lineCount: 설정할 라인 수
    @discardableResult
    func setNumberOfLines(lineCount: Int) -> Self {
        numberOfLines = lineCount
        return self
    }
    
    /// Label 폰트를 설정합니다. 동적 타입을 지원하도록 UIFontMetrics를 사용합니다
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
    
    /// Label 텍스트 정렬을 설정합니다.
    /// - Parameter alignment: 정렬 방식
    @discardableResult
    func setAlignment(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }
}
