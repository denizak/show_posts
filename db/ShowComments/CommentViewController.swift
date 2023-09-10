//
//  CommentViewController.swift
//  db
//
//  Created by Deni Zakya on 10/09/23.
//

import UIKit

final class CommentViewController: UIViewController {
    
    private let table: UITableView = {
        let table = UITableView(frame: .zero)
        table.accessibilityIdentifier = "comment_table"
        return table
    }()

    var postId: Int?
    private let cellIdentifier = "Cell"
    private var commentItems: [CommentItemResponse] = []
    private let commentRequester = CommentRequester()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

        Task {
            guard let postId = postId else { return }
            do {
                commentItems = try await commentRequester.request(postId: postId)
            } catch {
                print("unable to request comment")
            }
            await MainActor.run(body: {
                table.reloadData()
            })
        }
    }
    
    private func setUpView() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        table.dataSource = self
    }
}

extension CommentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        cell.setUp(item: commentItems[indexPath.row])
        cell.selectionStyle = .none
        cell.accessibilityIdentifier = "comment_cell"

        return cell
    }
}

extension UITableViewCell {
    func setUp(item: CommentItemResponse) {
        var content = defaultContentConfiguration()
        content.text = item.email
        content.secondaryText = item.body
        contentConfiguration = content
    }
}
