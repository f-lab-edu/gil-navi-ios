//
//  BasicTextField.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class BasicTextField: UITextField {
    enum FormType: Equatable {
        case email
        case password
        case unknown(placeholder: String)
        
        var contentType: UITextContentType {
            switch self {
            case .email:
                return .emailAddress 
            case .password:
                return .password
            case .unknown:
                return .init(rawValue: "unknown")
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            default:
                return .default
                
            }
        }
        
        var placeholder: String {
            switch self {
            case .email:
                return "Email"
            case .password:
                return "Password"
            case .unknown(let placeholder):
                return placeholder
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
        textColor: UIColor = .black,
        fontSize: CGFloat = 10,
        fontWeight: UIFont.Weight = .medium
    ) {
        super.init(frame: .zero)
        configureUI(formType: type,
                    returnKeyType: returnKeyType,
                    clearButtonMode: clearButtonMode,
                    textColor: textColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configurePlaceholderAndBorder()
        }
    }
}

// MARK: - Configure UI
extension BasicTextField {
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
        placeholder = formType.placeholder
        isSecureTextEntry = formType == .password
        returnKeyType = returnType
        clearButtonMode = clearMode
        textColor = .text
        applyDynamicTypeFont(textStyle: .body, size: fontSize, weight: fontWeight)
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.cornerRadius = 6
        autocorrectionType = .no
        autocapitalizationType = .none
        configurePlaceholderAndBorder()
    }

    private func configurePlaceholderAndBorder() {
        layer.borderColor = UIColor.borderGray.cgColor
        if let placeholder = placeholder {
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.placeholder]
            )
        }
    }
}
