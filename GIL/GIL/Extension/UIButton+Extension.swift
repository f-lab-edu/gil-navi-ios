//
//  UIButton+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/9/24.
//

import UIKit

extension UIButton {
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
        titleLabel?.font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    /**
     버튼에 '제출' 스타일을 적용합니다.
     - Parameter title: 버튼에 표시할 텍스트
    */
    func applySubmitStyle(title: String) {
        setTitle(title: title, state: .normal)
        setTitleColor(color: .white, state: .normal)
        setFont(textStyle: .body, size: 18, weight: .bold)
        setLayer(cornerRadius: 6)
        setBackgroundColor(.mainGreen, for: .normal)
        setBackgroundColor(.lightGray, for: .disabled)
    }
}

// MARK: - Method Chaining
extension UIButton {
    @discardableResult
    func setTitle(
        title: String,
        state: UIControl.State
    ) -> Self {
        setTitle(title.localized(), for: state)
        return self
    }
    
    @discardableResult
    func setTitleColor(
        color: UIColor?,
        state: UIControl.State
    ) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func setFont(
        textStyle: UIFont.TextStyle,
        size: CGFloat,
        weight: UIFont.Weight
    ) -> Self {
        applyDynamicTypeFont(textStyle: textStyle, size: size, weight: weight)
        return self
    }
    
    @discardableResult
    func setBackgroundImage(
        image: UIImage?,
        state: UIControl.State
    ) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    
    @discardableResult
    func setSysyemImage(
        name: String,
        state: UIControl.State = .normal,
        tintColor color: UIColor = .black
    ) -> Self {
        setImage(UIImage(systemName: name), for: state)
        tintColor = color
        return self
    }
    
    @discardableResult
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color?.cgColor ?? UIColor.clear.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setBackgroundImage(colorImage, for: state)
        }
        return self
    }

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
