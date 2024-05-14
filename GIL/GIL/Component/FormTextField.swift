//
//  FormTextField.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

final class FormTextField: UITextField {
    enum FormType: Equatable {
        case email
        case password
        case verifyPassword
        case unknown(placeholder: String)
        
        var contentType: UITextContentType {
            switch self {
            case .email: return .emailAddress
            case .password, .verifyPassword: return .password
            case .unknown: return .init(rawValue: "unknown")
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            default: return .default
            }
        }
        
        var placeholder: String {
            switch self {
            case .email: return "이메일"
            case .password: return "비밀번호"
            case .verifyPassword: return "비밀번호 확인"
            case .unknown(let placeholder): return placeholder
            }
        }
    }
    
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    static let validBorderColor = UIColor.mainGreen.cgColor
    static let invalidBorderColor = UIColor.red.cgColor
    
    // MARK: - Initialization
    init(
        type: FormType,
        returnKeyType: UIReturnKeyType = .default,
        clearButtonMode: UITextField.ViewMode = .never,
        textColor: UIColor = .mainText,
        fontSize: CGFloat = 10,
        fontWeight: UIFont.Weight = .medium
    ) {
        super.init(frame: .zero)
        configureUI(formType: type, returnKeyType: returnKeyType, clearButtonMode: clearButtonMode, textColor: textColor, fontSize: fontSize, fontWeight: fontWeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configurePlaceholderAndBorder()
        }
    }
}

// MARK: - UI Update
extension FormTextField {
    func updateBorderColor(_ isValid: Bool) {
        let color = isValid ? FormTextField.validBorderColor : FormTextField.invalidBorderColor
        layer.borderColor = color
    }
}

// MARK: - Configure UI
extension FormTextField {
    private func configureUI(
        formType: FormType,
        returnKeyType returnType: UIReturnKeyType,
        clearButtonMode clearMode: UITextField.ViewMode,
        textColor txtColor: UIColor,
        fontSize: CGFloat,
        fontWeight: UIFont.Weight
    ) {
        keyboardType = formType.keyboardType
        textContentType = formType.contentType
        placeholder = formType.placeholder.localized()
        isSecureTextEntry = (formType == .password) || (formType == .verifyPassword)
        returnKeyType = returnType
        clearButtonMode = clearMode
        textColor = txtColor
        setFont(textStyle: .body, size: fontSize, weight: fontWeight)
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.cornerRadius = 6
        autocorrectionType = .no
        autocapitalizationType = .none
        configurePlaceholderAndBorder()
    }

    private func configurePlaceholderAndBorder() {
        layer.borderColor = UIColor.lightGray.cgColor
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.mainPlaceholder]
            )
        }
    }
}
