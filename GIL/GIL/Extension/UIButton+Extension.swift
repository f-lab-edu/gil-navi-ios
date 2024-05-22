//
//  UIButton+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/9/24.
//

import UIKit

extension UIButton {
    /// 버튼에 `제출` 스타일을 적용합니다
    /// - Parameter title: 버튼에 표시할 텍스트
    @discardableResult
    func configureSubmitStyle(title: String) -> Self {
        setTitle(title: title, state: .normal)
        setTitleColor(color: .white, state: .normal)
        setFont(textStyle: .body, size: 18, weight: .bold)
        setLayer(cornerRadius: 6)
        setBackgroundColor(.mainGreen, for: .normal)
        setBackgroundColor(.lightGray, for: .disabled)
        return self
    }
    
    /// 버튼에 `네비게이션` 스타일을 적용합니다
    /// - Parameter type: 네비게이션 버튼 타입 (예: .back, .close)
    @discardableResult
    func configureNavigationStyle(type: NavigationButtonType) -> Self {
        let tintColor: UIColor = .lightBlackDarkWhite
        let originalImage = UIImage(systemName: type.systemImageName)
        let resizedImage = originalImage?.resized(toWidth: type.iconWidth)
        setImage(resizedImage?.withTintColor(tintColor), for: .normal)
        setTintColor(tintColor)
        return self
    }
}

extension UIButton {
    /// 버튼의 타이틀을 설정합니다
    /// - Parameters:
    ///   - title: 설정할 타이틀
    ///   - state: 버튼 상태
    @discardableResult
    func setTitle(
        title: String,
        state: UIControl.State
    ) -> Self {
        setTitle(title.localized(), for: state)
        return self
    }
    
    /// 버튼의 타이틀 색상을 설정합니다
    /// - Parameters:
    ///   - color: 적용할 색상
    ///   - state: 버튼 상태
    @discardableResult
    func setTitleColor(
        color: UIColor?,
        state: UIControl.State
    ) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    /// 버튼의 폰트를 설정합니다. 동적 타입을 지원하도록 UIFontMetrics를 사용합니다
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
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        titleLabel?.font = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
        titleLabel?.adjustsFontForContentSizeCategory = true
        return self
    }
    
    /// 버튼의 배경 이미지를 설정합니다
    /// - Parameters:
    ///   - image: 적용할 이미지
    ///   - state: 버튼 상태
    @discardableResult
    func setBackgroundImage(
        image: UIImage?,
        state: UIControl.State
    ) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
    
    /// 시스템 이미지를 버튼에 설정합니다
    /// - Parameters:
    ///   - name: 이미지 이름
    ///   - state: 기본 상태 설정
    @discardableResult
    func setSysyemImage(
        name: String,
        state: UIControl.State = .normal
    ) -> Self {
        setImage(UIImage(systemName: name), for: state)
        return self
    }
    
    /// 버튼의 틴트 색상을 설정합니다.
    @discardableResult
    func setTintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    /// 버튼의 배경 색상을 설정합니다. UIGraphics를 사용하여 배경으로 사용합니다
    /// - Parameters:
    ///   - color: 적용할 색상
    ///   - state: 버튼 상태
    @discardableResult
    func setBackgroundColor(
        _ color: UIColor?,
        for state: UIControl.State
    ) -> Self {
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
}
