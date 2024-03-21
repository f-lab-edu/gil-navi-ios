//
//  UITextField+Extension.swift
//  GIL
//
//  Created by 송우진 on 3/21/24.
//

import UIKit

extension UITextField {
    struct TextFieldConfiguration {
        var keyboardType: UIKeyboardType = .default
        var returnKeyType: UIReturnKeyType = .default
        var contentType: UITextContentType?
        var placeholder: String?
        var textColor: UIColor?
        var font: UIFont?
        var backgroundColor: UIColor?
        var borderColor: CGColor?
        var borderWidth: CGFloat?
        var cornerRadius: CGFloat?
        var autocorrectionType: UITextAutocorrectionType = .default
        var autocapitalizationType: UITextAutocapitalizationType = .sentences
        var isSecureTextEntry: Bool = false
        
    }
    
    // UITextField에 설정값을 적용하는 메서드
    func applyStyle(_ configuration: TextFieldConfiguration) {
        keyboardType = configuration.keyboardType
        returnKeyType = configuration.returnKeyType
        textContentType = configuration.contentType
        placeholder = configuration.placeholder
        textColor = configuration.textColor
        font = configuration.font
        backgroundColor = configuration.backgroundColor
        layer.borderColor = configuration.borderColor
        layer.borderWidth = configuration.borderWidth ?? 0
        layer.cornerRadius = configuration.cornerRadius ?? 0
        autocorrectionType = configuration.autocorrectionType
        autocapitalizationType = configuration.autocapitalizationType
        isSecureTextEntry = configuration.isSecureTextEntry
        
    }
}
