//
//  UIImageView+Extension.swift
//  GIL
//
//  Created by 송우진 on 5/15/24.
//

import UIKit

extension UIImageView {
    /// 이미지를 설정합니다
    /// - Parameter image: 이미지를 설정할 UIImage
    @discardableResult
    func setImage(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    /// 이미지를 설정합니다
    /// - Parameter image: 이미지를 설정할 UIImage
    @discardableResult
    func setContentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
}
