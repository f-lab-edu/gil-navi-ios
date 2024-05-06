//
//  MappinImageView.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

final class MappinImageView: BaseImageView {
    enum IconType {
        case filled
        case outline
        
        var imageName: String {
            switch self {
            case .filled: return "mappin.and.ellipse.circle.fill"
            case .outline: return "mappin.and.ellipse"
            }
        }
    }
    
    // MARK: - Initialization
    init(
        iconType: IconType,
        tintColor: UIColor = .mainGreen
    ) {
        let image = UIImage(systemName: iconType.imageName)
        super.init(image: image, contentMode: .scaleAspectFit, tintColor: tintColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
