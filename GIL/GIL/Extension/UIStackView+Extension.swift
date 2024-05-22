//
//  UIStackView+Extension.swift
//  GIL
//
//  Created by 송우진 on 5/13/24.
//

import UIKit

extension UIStackView {
    /// 스택 뷰의 축을 설정합니다
    /// - Parameter axis: 설정할 축 (가로 또는 세로)
    @discardableResult
    func setAxis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    
    /// 스택 뷰의 분배 방식을 설정합니다
    /// - Parameter distribution: 스택 뷰 내의 뷰들이 어떻게 분배될지 결정하는 방식
    @discardableResult
    func setDistribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    /// 스택 뷰의 정렬 방식을 설정합니다
    /// - Parameter alignment: 스택 뷰 내의 뷰들이 어떻게 정렬될지 결정하는 방식
    @discardableResult
    func setAlignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    
    /// 스택 뷰의 요소 사이의 간격을 설정합니다
    /// - Parameter spacing: 요소 사이의 간격
    @discardableResult
    func setSpacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
}
