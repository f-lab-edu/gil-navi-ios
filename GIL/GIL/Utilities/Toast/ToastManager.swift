//
//  ToastManager.swift
//  GIL
//
//  Created by 송우진 on 5/17/24.
//

import UIKit

final class ToastManager {
    static let shared = ToastManager()
    
    private weak var toastView: UIView?
    private init() {}
    
    enum ToastPosition {
        case top
        case bottom
    }

    @MainActor
    func showToast(
        message: String,
        duration: TimeInterval = 2.0,
        position: ToastPosition = .bottom
    ) {
        if let existingView = toastView { existingView.removeFromSuperview() }
        let view = ToastView(message: message)
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let window = windowScene?.windows.first {
            window.addSubview(view)
            setupConstraints(for: view, in: window, position: position)
            animateToast(view, duration: duration)
        }
        toastView = view
    }
    
    private func setupConstraints(
        for view: UIView,
        in window: UIWindow,
        position: ToastPosition
    ) {
        view.makeConstraints({
            switch position {
            case .top: $0.top(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 50)
            case .bottom: $0.bottom(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: 50)
            }
            $0.matchParent(window, attributes: [.leading, .trailing], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        })
    }
    
    private func animateToast(
        _ view: UIView,
        duration: TimeInterval
    ) {
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                view.alpha = 0.0
            }) { _ in
                view.removeFromSuperview()
            }
        }
    }
}
