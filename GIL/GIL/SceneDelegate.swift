//
//  SceneDelegate.swift
//  GIL
//
//  Created by 송우진 on 3/15/24.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        registerAuthStateDidChangeEvent()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
        
        updateRootViewControllerBasedOnAuthenticationStatus()
    }
    
    private func registerAuthStateDidChangeEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateRootViewControllerBasedOnAuthenticationStatus),
                                               name: .AuthStateDidChange,
                                               object: nil)
    }
    
    @objc private func updateRootViewControllerBasedOnAuthenticationStatus() {
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        interactor.presenter = presenter
        
        let homeViewController = HomeViewController(interactor: interactor)
        presenter.viewController = homeViewController
        
        let loginViewController = LoginViewController(viewModel: LoginViewModel())
        
        window?.rootViewController = (Auth.auth().currentUser != nil) ?
        UINavigationController(rootViewController: homeViewController) :
            UINavigationController(rootViewController: loginViewController)
        
        
    }
}

