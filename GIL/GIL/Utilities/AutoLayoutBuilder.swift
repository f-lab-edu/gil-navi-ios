//
//  AutoLayoutBuilder.swift
//  GIL
//
//  Created by 송우진 on 5/16/24.
//

import UIKit

extension UIView {
    // 뷰와 제약조건을 저장하는 NSMapTable, 메모리 관리 옵션을 설정
    private static var activeConstraints: NSMapTable<UIView, NSMutableDictionary> = NSMapTable(keyOptions: .weakMemory, valueOptions: .strongMemory)
    
    private var constraintsDictionary: [NSLayoutConstraint.Attribute: NSLayoutConstraint] {
        get {
            // 기존 제약조건을 가져오거나, 없으면 빈 딕셔너리 반환
            let constraintsDictionary = UIView.activeConstraints.object(forKey: self) as? [NSLayoutConstraint.Attribute: NSLayoutConstraint]
            return constraintsDictionary ?? [:]
        }
        set {
            UIView.activeConstraints.setObject(newValue as? NSMutableDictionary, forKey: self)
        }
    }
    
    func activateConstraint(
        _ constraint: NSLayoutConstraint,
        for attribute: NSLayoutConstraint.Attribute
    ) {
        // 기존 제약조건이 있다면 비활성화하고 제거
        if let existingConstraint = constraintsDictionary[attribute] {
            existingConstraint.isActive = false
            removeConstraint(existingConstraint)
        }
        // 새로운 제약조건을 딕셔너리에 저장하고 활성화
        constraintsDictionary[attribute] = constraint
        constraint.isActive = true
    }
    
    func makeConstraints(_ closure: (AutoLayoutBuilder) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        let builder = AutoLayoutBuilder(view: self)
        closure(builder)
    }
}

class AutoLayoutBuilder {
    private let view: UIView

    init(view: UIView) {
        self.view = view
    }
    
    // MARK: - 각 속성에 대한 제약조건 설정 함수들
    @discardableResult
    private func applyConstraint(
        _ constraint: NSLayoutConstraint,
        for attribute: NSLayoutConstraint.Attribute
    ) -> Self {
        view.activateConstraint(constraint, for: attribute)
        return self
    }

    @discardableResult
    func top(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0
    ) -> Self {
        let constraint = view.topAnchor.constraint(equalTo: anchor, constant: constant)
        return applyConstraint(constraint, for: .top)
    }

    @discardableResult
    func bottom(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0
    ) -> Self {
        let constraint = view.bottomAnchor.constraint(equalTo: anchor, constant: -constant)
        return applyConstraint(constraint, for: .bottom)
    }

    @discardableResult
    func leading(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0
    ) -> Self {
        let constraint = view.leadingAnchor.constraint(equalTo: anchor, constant: constant)
        return applyConstraint(constraint, for: .leading)
    }

    @discardableResult
    func trailing(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0
    ) -> Self {
        let constraint = view.trailingAnchor.constraint(equalTo: anchor, constant: -constant)
        return applyConstraint(constraint, for: .trailing)
    }

    @discardableResult
    func width(equalToConstant constant: CGFloat) -> Self {
        let constraint = view.widthAnchor.constraint(equalToConstant: constant)
        return applyConstraint(constraint, for: .width)
    }

    @discardableResult
    func height(
        equalToConstant constant: CGFloat
    ) -> Self {
        let constraint = view.heightAnchor.constraint(equalToConstant: constant)
        return applyConstraint(constraint, for: .height)
    }

    @discardableResult
    func centerX(
        equalTo anchor: NSLayoutXAxisAnchor,
        constant: CGFloat = 0
    ) -> Self {
        let constraint = view.centerXAnchor.constraint(equalTo: anchor, constant: constant)
        return applyConstraint(constraint, for: .centerX)
    }

    @discardableResult
    func centerY(
        equalTo anchor: NSLayoutYAxisAnchor,
        constant: CGFloat = 0
    ) -> Self {
        let constraint = view.centerYAnchor.constraint(equalTo: anchor, constant: constant)
        return applyConstraint(constraint, for: .centerY)
    }
    
    @discardableResult
    func size(_ size: CGSize) -> Self {
        let widthConstraint = view.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = view.heightAnchor.constraint(equalToConstant: size.height)
        applyConstraint(widthConstraint, for: .width)
        applyConstraint(heightConstraint, for: .height)
        return self
    }
    
    // 부모 뷰와의 제약조건 설정
    @discardableResult
    func matchParent(
        _ parentView: UIView,
        attributes: [NSLayoutConstraint.Attribute],
        insets: UIEdgeInsets = .zero
    ) -> Self {
        for attribute in attributes {
            switch attribute {
            case .top: top(equalTo: parentView.topAnchor, constant: insets.top)
            case .bottom: bottom(equalTo: parentView.bottomAnchor, constant: insets.bottom)
            case .leading: leading(equalTo: parentView.leadingAnchor, constant: insets.left)
            case .trailing: trailing(equalTo: parentView.trailingAnchor, constant: insets.right)
            case .width:
                let constraint = view.widthAnchor.constraint(equalTo: parentView.widthAnchor, constant: -(insets.left + insets.right))
                applyConstraint(constraint, for: .width)
            case .height:
                let constraint = view.heightAnchor.constraint(equalTo: parentView.heightAnchor, constant: -(insets.top + insets.bottom))
                applyConstraint(constraint, for: .height)
            case .centerX: centerX(equalTo: parentView.centerXAnchor, constant: insets.left - insets.right)
            case .centerY: centerY(equalTo: parentView.centerYAnchor, constant: insets.top - insets.bottom)
            default: break
            }
        }
        return self
    }
}
