//
//  BaseStackView.swift
//  GIL
//
//  Created by 송우진 on 5/2/24.
//

import UIKit

final class BaseStackView: UIStackView {
    // MARK: - Initializers
    init(
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fillEqually,
        alignment: UIStackView.Alignment = .fill,
        spacing: CGFloat = 0
    ) {
        super.init(frame: .zero)
        configure(axis: axis, distribution: distribution, alignment: alignment, spacing: spacing)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configure(
        axis stackAxis: NSLayoutConstraint.Axis,
        distribution stackDistribution: UIStackView.Distribution,
        alignment stackAlignment: UIStackView.Alignment,
        spacing stackSpacing: CGFloat
    ) {
        axis = stackAxis
        distribution = stackDistribution
        alignment = stackAlignment
        spacing = stackSpacing
    }
}
