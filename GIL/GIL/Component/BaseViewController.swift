//
//  BaseViewController.swift
//  GIL
//
//  Created by 송우진 on 4/24/24.
//

import UIKit
import Foundation

class BaseViewController: UIViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
    }
}

// MARK: - Setup
extension BaseViewController {
    private func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UI Handling
extension BaseViewController {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
