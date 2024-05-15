//
//  UIView+AccessibilityExtension.swift
//  GIL
//
//  Created by 송우진 on 5/15/24.
//

import UIKit

extension UIView {
    /// 접근성 레이블을 설정합니다
    /// - Parameter label: VoiceOver가 읽을 텍스트 레이블
    @discardableResult
    func setAccessibilityLabel(_ label: String) -> Self {
        accessibilityLabel = label
        return self
    }
    
    /// 접근성 힌트를 설정합니다
    /// - Parameter hint: VoiceOver가 읽을 추가적인 힌트 텍스트
    @discardableResult
    func setAccessibilityHint(_ hint: String) -> Self {
        accessibilityHint = hint
        return self
    }
    
    /// 접근성 트레이트를 설정합니다
    /// - Parameter traits: UI 요소의 특성 (버튼, 선택됨 등)
    @discardableResult
    func setAccessibilityTraits(_ traits: UIAccessibilityTraits) -> Self {
        accessibilityTraits = traits
        return self
    }
    
    /// 접근성 값을 설정합니다
    /// - Parameter value: UI 요소의 현재 상태 값
    @discardableResult
    func setAccessibilityValue(_ value: String) -> Self {
        accessibilityValue = value
        return self
    }
    
    /// 접근성 식별자를 설정합니다
    /// - Parameter identifier: 고유 식별자
    @discardableResult
    func setAccessibilityIdentifier(_ identifier: String) -> Self {
        accessibilityIdentifier = identifier
        return self
    }
    
    /// 접근성 요소로 설정합니다
    /// - Parameter isElement: 접근성 요소인지 여부
    @discardableResult
    func setIsAccessibilityElement(_ isElement: Bool) -> Self {
        isAccessibilityElement = isElement
        return self
    }
    
    /// 접근성 요소 그룹을 설정합니다
    /// - Parameter elements: 접근성 요소로 묶을 하위 요소 배열
    @discardableResult
    func setAccessibilityElements(_ elements: [Any]?) -> Self {
        accessibilityElements = elements
        return self
    }
}
