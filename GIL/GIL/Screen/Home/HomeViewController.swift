//
//  HomeViewController.swift
//  GIL
//
//  Created by 송우진 on 4/4/24.
//

import UIKit

protocol HomeDisplayLogic {
    func displaySearchScreen()
}

final class HomeViewController: BaseViewController, NavigationBarHideable {
    private var interactor: HomeBusinessLogic
    private var homeView = HomeView()
    
    
    // MARK: - Initialization
    init(interactor: HomeBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: false)
    }
}

// MARK: - HomeDisplayLogic
extension HomeViewController: HomeDisplayLogic {
    func displaySearchScreen() {
        let searchDetailVC = UIViewController()
        searchDetailVC.view.backgroundColor = .systemPink
        navigationController?.pushViewController(searchDetailVC, animated: true)
    }
}

// MARK: - Binding
extension HomeViewController {
    func setupBindings() {
        bindCollection()
    }

    private func bindCollection() {
        homeView.mainCollectionView.dataSource = self
        homeView.mainCollectionView.delegate = self
        
        homeView.mainCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "NormalCell")
        homeView.mainCollectionView.register(HomeSearchCollectionViewCell.self, forCellWithReuseIdentifier: HomeSearchCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSearchCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeSearchCollectionViewCell {
                
                cell.onSearchBarTapped = { [weak self] in
                    guard let self else { return }
                    self.interactor.performSearch()
                }
                
                return cell
            }
            
        default: break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NormalCell", for: indexPath)
        cell.backgroundColor = .gray
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 80)
        default:
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
}
