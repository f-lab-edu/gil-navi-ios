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
    private var lightModePlaceholderColor: UIColor = .lightGray
    private var darkModePlaceholderColor: UIColor = .white
    private let lightModeBorderColor = UIColor.lightGray.cgColor
    private let darkModeBorderColor = UIColor.darkGray.cgColor
    
    static let validBorderColor = UIColor.mainGreenColor?.cgColor
    static let invalidBorderColor = UIColor.red.cgColor
    
    // MARK: - Initialization
    init(
        type: FormType,
        returnKeyType: UIReturnKeyType = .default,
        clearButtonMode: UITextField.ViewMode = .never,
        textColor: UIColor = .black,
        font: UIFont = .systemFont(ofSize: 14, weight: .medium)
    ) {
        super.init(frame: .zero)
        configureUI(formType: type,
                    returnKeyType: returnKeyType,
                    clearButtonMode: clearButtonMode,
                    textColor: textColor,
                    font: font)
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

        if let placeholder = placeholder,
           traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = (traitCollection.userInterfaceStyle == .dark ? darkModeBorderColor : lightModeBorderColor)
            
            let placeholderColor = traitCollection.userInterfaceStyle == .dark ? darkModePlaceholderColor : lightModePlaceholderColor
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: placeholderColor])
        }
    }
}

// MARK: - Configure UI
extension BasicTextField {
    func configureUI(
        formType: FormType,
        returnKeyType returnType: UIReturnKeyType,
        clearButtonMode clearMode: UITextField.ViewMode,
        textColor txtColor: UIColor,
        font txtFont: UIFont
    ) {
        keyboardType = formType.keyboardType
        textContentType = formType.contentType
        placeholder = formType.placeholder
        isSecureTextEntry = formType == .password
        returnKeyType = returnType
        clearButtonMode = clearMode
        textColor = txtColor
        font = txtFont
        backgroundColor = .systemBackground
        layer.borderColor = (traitCollection.userInterfaceStyle == .dark) ? darkModeBorderColor : lightModeBorderColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
        autocorrectionType = .no
        autocapitalizationType = .none
        let placeholderColor = (traitCollection.userInterfaceStyle == .dark) ? darkModePlaceholderColor : lightModePlaceholderColor
        if let placeholderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: placeholderColor])
        }
    }
}
