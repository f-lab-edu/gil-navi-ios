//
//  UIViewController+NavigationBarHideable.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//

import UIKit

protocol NavigationBarHideable {
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(animated: Bool)
}

extension NavigationBarHideable where Self: UIViewController {
    func hideNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
