//
//  ViewController.swift
//  db
//
//  Created by deni zakya on 08/09/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let table: UITableView = {
        let table = UITableView(frame: .zero)
        return table
    }()

    private let dataSource = PostsTableViewDataSource()
    private let viewModel = ShowPostsViewModel.make()
    private var subscribers: [AnyCancellable] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        table.dataSource = dataSource

        viewModel.items.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] items in
                self.dataSource.items = items
                self.table.reloadData()
            })
            .store(in: &subscribers)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewAppear()
    }
}
