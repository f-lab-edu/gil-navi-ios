//
//  HomeViewController.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
