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
    
    /// 식별자를 설정합니다
    /// - Parameter identifier: 접근성 식별자
    @discardableResult
    func setAccessibilityIdentifier(_ identifier: String) -> Self {
        accessibilityIdentifier = identifier
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

// MARK: - AutoLayout
extension UIView {
    private static var activeConstraints: NSMapTable<UIView, NSDictionary> = NSMapTable(keyOptions: .weakMemory, valueOptions: .strongMemory)

    /// 현재 뷰에 연결된 제약 조건을 관리하는 속성입니다.
    private var viewConstraints: [NSLayoutConstraint.Attribute: NSLayoutConstraint] {
        get {
            let constraintsDictionary = UIView.activeConstraints.object(forKey: self) as? [NSLayoutConstraint.Attribute: NSLayoutConstraint]
            return constraintsDictionary ?? [:]
        }
        set {
            UIView.activeConstraints.setObject(newValue as NSDictionary, forKey: self)
        }
    }
    
    /// 제약 조건을 활성화하고 필요하면 기존 제약을 비활성화합니다.
    private func activateConstraint(
        _ constraint: NSLayoutConstraint,
        for attribute: NSLayoutConstraint.Attribute
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let existingConstraint = viewConstraints[attribute] {
            existingConstraint.isActive = false
            removeConstraint(existingConstraint)
        }

        viewConstraints[attribute] = constraint
        constraint.isActive = true
    }

    /// 주어진 앵커에 대해 왼쪽 제약을 추가합니다.
    /// - Parameters:
    ///   - anchor: 왼쪽 제약을 맞출 앵커
    ///   - constant: 앵커와의 간격 (기본값은 0)
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func left(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0.0
    ) -> UIView {
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        activateConstraint(constraint, for: .leading)
        return self
    }

    /// 주어진 앵커에 대해 오른쪽 제약을 추가합니다.
    /// - Parameters:
    ///   - anchor: 오른쪽 제약을 맞출 앵커
    ///   - constant: 앵커와의 간격 (기본값은 0)
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func right(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0.0
    ) -> UIView {
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: constant)
        activateConstraint(constraint, for: .trailing)
        return self
    }

    /// 주어진 앵커에 대해 상단 제약을 추가합니다.
    /// - Parameters:
    ///   - anchor: 상단 제약을 맞출 앵커
    ///   - constant: 앵커와의 간격 (기본값은 0)
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func top(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0.0
    ) -> UIView {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: constant)
        activateConstraint(constraint, for: .top)
        return self
    }

    /// 주어진 앵커에 대해 하단 제약을 추가합니다.
    /// - Parameters:
    ///   - anchor: 하단 제약을 맞출 앵커
    ///   - constant: 앵커와의 간격 (기본값은 0)
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func bottom(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0.0
    ) -> UIView {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: constant)
        activateConstraint(constraint, for: .bottom)
        return self
    }
    
    /// 주어진 앵커에 대해 가로 중심 제약을 추가합니다.
    /// - Parameters:
    ///   - anchor: 가로 중심 제약을 맞출 앵커
    ///   - constant: 앵커와의 간격 (기본값은 0)
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func centerX(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0.0
    ) -> UIView {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: constant)
        activateConstraint(constraint, for: .centerX)
        return self
    }
    
    /// 주어진 앵커에 대해 세로 중심 제약을 추가합니다.
    /// - Parameters:
    ///   - anchor: 세로 중심 제약을 맞출 앵커
    ///   - constant: 앵커와의 간격 (기본값은 0)
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func centerY(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0.0
    ) -> UIView {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: constant)
        activateConstraint(constraint, for: .centerY)
        return self
    }

    /// 지정된 상수 값에 대한 너비 제약을 추가합니다.
    /// - Parameter constant: 너비 값
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func width(_ constant: CGFloat) -> UIView {
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        activateConstraint(constraint, for: .width)
        return self
    }
    
    /// 지정된 상수 값에 대한 높이 제약을 추가합니다.
    /// - Parameter constant: 높이 값
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func height(_ constant: CGFloat) -> UIView {
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        activateConstraint(constraint, for: .height)
        return self
    }
    
    /// 주어진 크기에 맞는 너비와 높이 제약을 추가합니다.
    /// - Parameter size: 너비와 높이를 지정하는 CGSize 값
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func size(_ size: CGSize) -> UIView {
        let widthConstraint = widthAnchor.constraint(equalToConstant: size.width)
        activateConstraint(widthConstraint, for: .width)
        
        let heightConstraint = heightAnchor.constraint(equalToConstant: size.height)
        activateConstraint(heightConstraint, for: .height)
        return self
    }
    
    /// 다른 뷰와 일치하는 속성에 대한 제약을 추가합니다.
    /// - Parameters:
    ///   - matchView: 제약을 맞출 대상 뷰
    ///   - attributes: 적용할 제약의 속성 배열
    /// - Returns: 메서드를 호출한 UIView 객체를 반환합니다.
    @discardableResult
    func applyConstraints(
        to matchView: UIView,
        attributes: [NSLayoutConstraint.Attribute]
    ) -> UIView {
        attributes.forEach { attribute in
            switch attribute {
            case .leading:
                let constraint = leadingAnchor.constraint(equalTo: matchView.leadingAnchor)
                activateConstraint(constraint, for: .leading)
            case .trailing:
                let constraint = trailingAnchor.constraint(equalTo: matchView.trailingAnchor)
                activateConstraint(constraint, for: .trailing)
            case .top:
                let constraint = topAnchor.constraint(equalTo: matchView.topAnchor)
                activateConstraint(constraint, for: .top)
            case .bottom:
                let constraint = bottomAnchor.constraint(equalTo: matchView.bottomAnchor)
                activateConstraint(constraint, for: .bottom)
            case .width:
                let constraint = widthAnchor.constraint(equalTo: matchView.widthAnchor)
                activateConstraint(constraint, for: .width)
            case .height:
                let constraint = heightAnchor.constraint(equalTo: matchView.heightAnchor)
                activateConstraint(constraint, for: .height)
            case .centerX:
                let constraint = centerXAnchor.constraint(equalTo: matchView.centerXAnchor)
                activateConstraint(constraint, for: .centerX)
            case .centerY:
                let constraint = centerYAnchor.constraint(equalTo: matchView.centerYAnchor)
                activateConstraint(constraint, for: .centerY)
            default: break
            }
        }
        return self
    }
}
