//
//  MappinImageView.swift
//  GIL
//
//  Created by 송우진 on 5/1/24.
//

import UIKit

final class MappinImageView: UIImageView {
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
        super.init(frame: .zero)
        setupIcon(iconType: iconType, tintColor: tintColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension MappinImageView {
    func setupIcon(
        iconType: IconType,
        tintColor color: UIColor
    ) {
        contentMode = .scaleAspectFit
        tintColor = color
        image = UIImage(systemName: iconType.imageName)
    }
}
