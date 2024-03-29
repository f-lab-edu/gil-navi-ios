//
//  BasicTextField.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class BasicTextField: UITextField {
    enum FormType {
        case email
        case password
        
        var contentType: UITextContentType {
            switch self {
            case .email:
                return .emailAddress
            case .password:
                return .password
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            case .password:
                return .default
            }
        }
        
        var placeholder: String {
            switch self {
            case .email:
                return "Email"
            case .password:
                return "Password"
            }
        }
    }
    
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    
    // MARK: - Initialization
    init(
        type: FormType,
        returnKeyType: UIReturnKeyType = .default,
        textColor: UIColor = .black,
        font: UIFont = .systemFont(ofSize: 14, weight: .medium)
    ) {
        super.init(frame: .zero)

        configureUI(formType: type,
                    returnKeyType: returnKeyType,
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
    
}

// MARK: - Configure UI
extension BasicTextField {
    func configureUI(
        formType: FormType,
        returnKeyType returnType: UIReturnKeyType,
        textColor txtColor: UIColor,
        font txtFont: UIFont
    ) {
        keyboardType = formType.keyboardType
        textContentType = formType.contentType
        placeholder = formType.placeholder
        isSecureTextEntry = formType == .password
        returnKeyType = returnType
        textColor = txtColor
        font = txtFont
        backgroundColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}
