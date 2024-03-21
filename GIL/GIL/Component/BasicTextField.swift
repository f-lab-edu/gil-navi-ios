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
    private let formType: FormType
    private let returnType: UIReturnKeyType
    
    // MARK: - Initialization
    init(type: FormType,
         returnKeyType: UIReturnKeyType = .default
    ) {
        self.formType = type
        self.returnType = returnKeyType
        super.init(frame: .zero)

        configureUI()
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
    func configureUI() {
        let config = TextFieldConfiguration(keyboardType: formType.keyboardType,
                                            returnKeyType: returnType,
                                            contentType: formType.contentType,
                                            placeholder: formType.placeholder,
                                            textColor: .black,
                                            font: .systemFont(ofSize: 14, weight: .medium),
                                            borderColor: UIColor.lightGray.cgColor,
                                            borderWidth: 1,
                                            cornerRadius: 6,
                                            autocorrectionType: .no,
                                            autocapitalizationType: .none,
                                            isSecureTextEntry: formType == .password ? true : false)
        applyStyle(config)
    }
}
