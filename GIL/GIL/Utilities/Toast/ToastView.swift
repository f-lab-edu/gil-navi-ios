//
//  ToastView.swift
//  GIL
//
//  Created by 송우진 on 5/17/24.
//

import UIKit

class ToastView: UIView {
    private let messageLabel = UILabel()
    
    // MARK: - Initialization
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension ToastView {
    private func setupUI() {
        addSubviews()
        setupToastView()
        setupMessageLabel()
    }
    
    private func addSubviews() {
        addSubview(messageLabel)
    }
    
    private func setupToastView() {
        setBackgroundColor(UIColor.black.withAlphaComponent(0.6))
        setLayer(cornerRadius: 10)
        setAlpha(0)
    }
    
    private func setupMessageLabel() {
        messageLabel
            .setTextColor(textColor: .white)
            .setAlignment(.center)
            .setFont(textStyle: .body, size: 14, weight: .medium)
            .setNumberOfLines(lineCount: 0)
            .makeConstraints({
                $0.matchParent(self, attributes: [.leading, .trailing, .bottom, .top], insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
            })
    }
}
