//
//  StatusbarManager.swift
//  GIL
//
//  Created by 송우진 on 4/1/24.
//

import UIKit

final class StatusBarManager {
    static let shared = StatusBarManager()
    
    let statusBarHeight: CGFloat
    
    private init() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            self.statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            self.statusBarHeight = 0
        }
    }
}
