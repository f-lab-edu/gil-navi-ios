//
//  UIView+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import UIKit

extension UIView {
    /// 뷰의 지정된 위치에 테두리를 추가합니다.
    /// - Parameters:
    ///   - position: 테두리의 위치(`.top` 또는 `.bottom` 중 하나)
    ///   - color: 테두리의 색상
    ///   - height: 테두리의 두께
    func addBorder(
        at position: BorderPosition,
        color: UIColor = .lightGrayBorder,
        height: CGFloat = 1
    ) {
        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch position {
        case .top: border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: height)
        case .bottom: border.frame = CGRect(x: 0, y: frame.size.height - height, width: frame.size.width, height: height)
        }
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    
    /// 뷰에 테두리를 추가할 수 있는 위치를 정의합니다.
    /// - top : 상단 테두리
    /// - bottom: 하단 테두리
    enum BorderPosition: String {
        case top = "topBorder"
        case bottom = "bottomBorder"
    }
}
