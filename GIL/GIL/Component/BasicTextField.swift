//
//  BasicTextField.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

final class BasicTextField: UITextField {
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
    static let defaultBorderColor = UIColor.lightGray.cgColor
    static let validBorderColor = UIColor.mainGreenColor?.cgColor
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
    
}

// MARK: - Configure UI
extension BasicTextField {
    func configureUI(
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
        textColor = txtColor
        applyDynamicTypeFont(textStyle: .body, size: fontSize, weight: fontWeight)
        backgroundColor = .white
        layer.borderColor = BasicTextField.defaultBorderColor
        layer.borderWidth = 1
        layer.cornerRadius = 6
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}
