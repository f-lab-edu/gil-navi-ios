//
//  SceneDelegate.swift
//  GIL
//
//  Created by 송우진 on 3/15/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        FirebaseAuthManager.registerAuthStateDidChangeHandler()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRootViewControllerBasedOnAuthenticationStatus), name: FirebaseAuthManager.authStateDidChangeNotification, object: nil)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
        
        updateRootViewControllerBasedOnAuthenticationStatus()
    }
    
    @objc private func updateRootViewControllerBasedOnAuthenticationStatus() {
        let homeViewController = HomeViewController()
        let loginViewController = LoginViewController(viewModel: LoginViewModel())
        window?.rootViewController = UINavigationController(rootViewController: (FirebaseAuthManager.currentUser != nil) ? homeViewController : loginViewController)
    }
}

