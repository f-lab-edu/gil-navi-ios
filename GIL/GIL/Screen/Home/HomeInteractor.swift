//
//  HomeInteractor.swift
//  GIL
//
//  Created by 송우진 on 4/23/24.
//

import Foundation

protocol HomeBusinessLogic {
    func performSearch()
}

final class HomeInteractor: HomeBusinessLogic {
    var presenter: HomePresentationLogic?
    
    func performSearch() {
        presenter?.presentSearchScreen()
    }
}
