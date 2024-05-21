//
//  SceneDelegate.swift
//  GIL
//
//  Created by 송우진 on 3/15/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let appDIContainer = AppDIContainer()
    let firebaseAuthManager = FirebaseAuthManager()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.backgroundColor = .systemBackground
        window.windowScene = windowScene
        self.window = window
        appFlowCoordinator = AppFlowCoordinator(
            window: window,
            appDIContainer: appDIContainer,
            firebaseAuthManager: firebaseAuthManager
        )
        appFlowCoordinator?.start()
    }
}
