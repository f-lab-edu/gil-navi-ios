//
//  BasicButton.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class BasicButton: UIButton {
    
    // MARK: - Initialization
    init(title: String) {
        super.init(frame: .zero)
        configureUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Configure UI
extension BasicButton {
    func configureUI(title: String) {
        let config = ButtonConfiguration(title: title,
                                         titleColor: .white,
                                         font: .systemFont(ofSize: 18, weight: .bold),
                                         backgroundColor: .mainGreenColor,
                                         cornerRadius: 6)
        applyStyle(config)
    }
}

