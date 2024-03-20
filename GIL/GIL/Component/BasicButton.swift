//
//  BasicButton.swift
//  GIL
//
//  Created by 송우진 on 3/18/24.
//

import UIKit

class BasicButton: UIButton {
    
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
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .mainGreenColor
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        layer.cornerRadius = 6
    }
}
