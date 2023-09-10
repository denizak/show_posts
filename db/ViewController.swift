//
//  ViewController.swift
//  db
//
//  Created by deni zakya on 08/09/23.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    private let table: UITableView = {
        let table = UITableView(frame: .zero)
        return table
    }()

    private let unitSelector: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Favorite"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.accessibilityIdentifier = "filter"
        return segmentedControl
    }()

    private let dataSource = PostsTableViewDataSource()
    private let viewModel = ShowPostsViewModel.make()
    private var subscribers: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        setUpView()

        dataSource.onFavoriteTap = { [unowned self] selectedItem in
            self.viewModel.toggleFavorite(item: selectedItem)
        }
        dataSource.onCellTap = { [unowned self] selectedItem in
            self.showCommentView(item: selectedItem)
        }
    }

    private func setUpView() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        table.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        table.dataSource = dataSource
        table.delegate = dataSource

        table.tableHeaderView = unitSelector

        unitSelector.addTarget(self, action: #selector(unitValueChanged), for: .valueChanged)
    }

    private func bindView() {
        viewModel.items.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] items in
                self.dataSource.items = items
                self.table.reloadData()
                self.table.isHidden = false
            })
            .store(in: &subscribers)
        viewModel.showErrorView.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self]  in
                self.table.reloadData()
                self.table.isHidden = true
            })
            .store(in: &subscribers)
        viewModel.showLoginView.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                self.showLoginView()
            })
            .store(in: &subscribers)
    }

    private func showLoginView() {
        let loginView = LoginViewController()
        loginView.onDismiss = { [unowned self] in
            self.viewModel.viewAppear()
        }
        present(loginView, animated: false)
    }
    
    private func showCommentView(item: PostItem) {
        let view = CommentViewController()
        view.postId = item.id
        present(view, animated: true)
    }

    @objc
    private func unitValueChanged(_ sender: UISegmentedControl) {
        viewModel.toggleFilter(filter: sender.selectedFilter)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewAppear()
    }
}

extension UISegmentedControl {
    var selectedFilter: Filter {
        self.selectedSegmentIndex == 1 ? .favorite : .all
    }
}
