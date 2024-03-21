//
//  UIButton+Extension.swift
//  GIL
//
//  Created by 송우진 on 3/21/24.
//

import UIKit

extension UIButton {
    struct ButtonConfiguration {
        var title: String?
        var titleColor: UIColor?
        var font: UIFont?
        var backgroundColor: UIColor?
        var cornerRadius: CGFloat?
    }
    
    // 버튼에 설정값을 적용하는 메서드
    func applyStyle(_ configuration: ButtonConfiguration) {
        setTitle(configuration.title, for: .normal)
        setTitleColor(configuration.titleColor, for: .normal)
        titleLabel?.font = configuration.font
        backgroundColor = configuration.backgroundColor
        layer.cornerRadius = configuration.cornerRadius ?? 0
    }
}
