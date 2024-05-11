//
//  AlertService.swift
//  GIL
//
//  Created by 송우진 on 4/21/24.
//

import UIKit

enum AlertService {
    static func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction]? = nil
    ) {
        Task {
            guard let viewController = await topMostViewController() else { return }
            let alertController = await UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let actions = actions, !actions.isEmpty {
                for action in actions {
                    await alertController.addAction(action)
                }
            } else {
                await alertController.addAction(okAction())
            }
            await MainActor.run {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func okAction(
        title: String = "확인".localized(),
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        UIAlertAction(title: title, style: .default, handler: handler)
    }
    
    static func cancelAction(
        title: String = "취소".localized(),
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        UIAlertAction(title: title, style: .cancel, handler: handler)
    }
    
    @MainActor
    private static func topMostViewController() -> UIViewController? {
        guard 
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController 
        else { return nil }
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
