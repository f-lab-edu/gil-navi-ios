//
//  LoadingView.swift
//  GIL
//
//  Created by 송우진 on 5/24/24.
//

import UIKit

class LoadingView {
    static var spinner: UIActivityIndicatorView?
    
    static func show() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard spinner == nil, let window = windowScene?.windows.first else { return }
        Task {
            await MainActor.run {
                let spinner = UIActivityIndicatorView(frame: UIScreen.main.bounds)
                spinner.backgroundColor = .black.withAlphaComponent(0.2)
                spinner.style = .large
                window.addSubview(spinner)
                spinner.startAnimating()
                self.spinner = spinner
            }
        }
    }
    
    static func hide() {
        guard let spinner = spinner else { return }
        Task {
            await MainActor.run {
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                self.spinner = nil
            }
        }
    }
}

