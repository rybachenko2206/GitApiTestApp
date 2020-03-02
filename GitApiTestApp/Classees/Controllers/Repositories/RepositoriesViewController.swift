//
//  RepositoriesViewController.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController, Storyboardable {
 
    // MARK: - Outlets
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    static var storyboardName: Storyboard {
        return .main
    }

    private let viewModel = RepositoriesViewModel()
    
    
    // MARK: - Overriden funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindViewModel()
        
        viewModel.getRepositories()
    }
    

    // MARK: - Private funcs
    
    private func bindViewModel() {
        self.title = viewModel.title
        
        viewModel.isLoadingHandler = { [weak self] isLoading in
            self?.handleIsLoading(isLoading)
        }
        
        viewModel.errorHandler = { [weak self] error in
            AlertManager.showServerErrorAlert(with: error, to: self)
        }
        
        viewModel.repositoriesReceived = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
        footerView.backgroundColor = .clear
        tableView.tableFooterView = footerView
        
        tableView.registerCell(RepositoryCell.self)
        tableView.estimatedRowHeight = RepositoryCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func handleIsLoading(_ isLoading: Bool) {
        if isLoading {
            activityindicator.startAnimating()
        } else {
            activityindicator.stopAnimating()
        }
    }
    
}


extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let repoItem = viewModel.repoItem(at: indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RepositoryCell.self)
        cell.nameLabel.text = repoItem.fullName
        cell.descriptionLabel.text = repoItem.description ?? "- no description -"
        cell.pushedAtLabel.text = CustomDateForrmatter.shared.string(from: repoItem.pushedAt, with: .showFullFormat)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



