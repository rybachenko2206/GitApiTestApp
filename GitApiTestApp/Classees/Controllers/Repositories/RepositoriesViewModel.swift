//
//  RepositoriesViewModel.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


class RepositoriesViewModel {
    
    private (set) var items: [RepositoryItem] = []
    
    var isLoadingHandler: BoolCompletion?
    var errorHandler: FailureHandler?
    var repositoriesReceived: Completion?
    
    let title = "Repositories"
    
    
    func getRepositories() {
        let orgName = "square"
        isLoadingHandler?(true)
        WebService.shared.getRepositories(for: orgName, completion: { [weak self] repos in
            self?.items = repos
            DispatchQueue.main.async {
                self?.isLoadingHandler?(false)
                self?.repositoriesReceived?()
            }
            
        }, failure: { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoadingHandler?(false)
                self?.errorHandler?(error)
            }
        })
    }
    
    
    func numberOfRows(in section: Int) -> Int {
        return items.count
    }
    
    func repoItem(at index: Int) -> RepositoryItem? {
        return items[safe: index]
    }
    
}
