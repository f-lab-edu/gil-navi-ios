//
//  UIView+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/29/24.
//

import UIKit

// MARK: - Border
extension UIView {
    /// 뷰의 지정된 위치에 테두리를 추가합니다.
    /// - Parameters:
    ///   - position: 테두리의 위치(`.top` 또는 `.bottom` 중 하나)
    ///   - color: 테두리의 색상
    ///   - height: 테두리의 두께
    func applyBorder(
        at position: BorderPosition,
        color: UIColor = .lightGray,
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

// MARK: - Configuration
extension UIView {
    /// 뷰의 배경색을 설정합니다
    /// - Parameter color: 배경색으로 설정할 컬러
    @discardableResult
    func setBackgroundColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }
    
    /// 뷰의 틴트 색상을 설정합니다
    /// - Parameter color: 틴트 색상으로 설정할 컬러
    @discardableResult
    func setTintColor(_ color: UIColor?) -> Self {
        tintColor = color
        return self
    }
    
    /// 뷰의 숨김 상태를 설정합니다
    /// - Parameter isHidden: 뷰를 숨길지 여부를 결정하는 Boolean 값
    @discardableResult
    func setIsHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 뷰의 레이어 속성(모서리 둥글기, 테두리 색상, 테두리 너비)을 설정합니다
    /// - Parameters:
    ///   - cornerRadius: 모서리의 둥근 정도
    ///   - borderColor: 테두리의 색상 설정, 기본값은 nil
    ///   - borderWidth: 테두리의 너비를 설정, 기본값은 0
    @discardableResult
    func setLayer(
        cornerRadius: CGFloat,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0
    ) -> Self {
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        clipsToBounds = true
        return self
    }
    
    /// 뷰의 위치와 크기를 설정합니다
    /// - Parameters:
    ///   - x: x축 위치
    ///   - y: y축 위치
    ///   - width: 너비
    ///   - height: 높이
    @discardableResult
    func setFrame(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat
    ) -> Self {
        frame = CGRect(x: x, y: y, width: width, height: height)
        return self
    }
    
    /// 뷰의 그림자 속성(색상, 오프셋, 반경, 불투명도, 경로)을 설정합니다
    /// - Parameters:
    ///   - color: 그림자의 색상, 기본값은 nil
    ///   - offset: 그림자의 오프셋, 기본값은 (0, 0)
    ///   - radius: 그림자의 반경
    ///   - opacity: 그림자의 불투명도, 기본값은 0
    ///   - path: 그림자의 경로, 기본값은 nil
    @discardableResult
    func setShadow(
        color: UIColor? = nil,
        offset: CGSize = CGSize(width: 0, height: 0),
        radius: CGFloat = 0,
        opacity: Float = 0,
        path: CGPath? = nil
    ) -> Self {
        layer.shadowColor = color?.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowPath = path
        clipsToBounds = false
        return self
    }
}
