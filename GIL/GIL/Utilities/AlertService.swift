//
//  AlertService.swift
//  GIL
//
//  Created by 송우진 on 4/21/24.
//

import UIKit

class AlertService {
    func showAlert(title: String,
                   message: String,
                   on viewController: UIViewController,
                   actions: [UIAlertAction]? = nil
    ) {
        Task {
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
    
    func okAction(title: String = "확인") -> UIAlertAction {
        UIAlertAction(title: title, style: .default, handler: nil)
    }
    
    func cancelAction(title: String = "취소",
                      handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertAction {
        UIAlertAction(title: title, style: .cancel, handler: handler)
    }
}
