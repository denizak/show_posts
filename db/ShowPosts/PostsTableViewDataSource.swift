//
//  PostsTableViewDataSource.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import UIKit

final class PostsTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var items: [PostItem] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell
        else { return UITableViewCell() }

        cell.update(item: items[indexPath.row])

        return cell
    }
}
