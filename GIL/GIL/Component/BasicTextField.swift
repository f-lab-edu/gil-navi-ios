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
        case unknown
        
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
            case .unknown:
                return ""
            }
        }
    }
    
    private let padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    private let formType: FormType
    
    init(type: FormType,
         placeholder: String? = nil,
         returnType: UIReturnKeyType? = nil
    ) {
        self.formType = type
        super.init(frame: .zero)
        
        self.placeholder = placeholder ?? self.formType.placeholder
        self.returnKeyType = returnType ?? .default
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        keyboardType = formType.keyboardType
        textColor = .black
        font = .systemFont(ofSize: 14, weight: .medium)
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
        autocorrectionType = .no
        autocapitalizationType = .none
        isSecureTextEntry = formType == .password ? true : false
        
    }
}
