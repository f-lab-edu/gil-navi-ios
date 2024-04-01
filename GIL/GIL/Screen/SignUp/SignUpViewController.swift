//
//  SignUpViewController.swift
//  GIL
//
//  Created by 송우진 on 3/26/24.
//

import UIKit

class SignUpViewController: UIViewController {
    private var signUpView = SignUpView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: - Binding
extension SignUpViewController {
    func setupBindings() {
        bindButtons()
    }
    
    private func bindButtons() {
        let closeAction = UIAction { _ in self.closeButtonTapped() }
        signUpView.closeButton.addAction(closeAction, for: .touchUpInside)
        
        let confirmAction = UIAction { _ in self.confirmButtonTapped() }
        signUpView.confirmButton.addAction(confirmAction, for: .touchUpInside)
    }
}

// MARK: - Action
extension SignUpViewController {
    func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    func confirmButtonTapped() {
        dismiss(animated: true)
    }
}
