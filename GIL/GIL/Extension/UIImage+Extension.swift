//
//  UIImage+Extension.swift
//  GIL
//
//  Created by 송우진 on 4/15/24.
//

import UIKit

extension UIImage {
    /// 주어진 너비로 이미지의 크기를 조정하면서 종횡비를 유지합니다.
    /// - Parameters:
    ///   - width: 이미지의 원하는 너비. 이 너비에 기반하여 높이가 계산됩니다.
    ///   - size: 폰트 크기
    ///   - weight: 폰트 무게
    /// - Returns: 지정된 너비를 가진 새로운 UIImage 객체를 반환하거나, 이미지 조정이 실패했을 경우 nil을 반환합니다.
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(
            width: width,
            height: CGFloat(ceil(width/size.width * size.height))
        )
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
