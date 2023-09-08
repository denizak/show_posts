//
//  PostCell.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import UIKit

final class PostCell: UITableViewCell {
    static let identifier = "Cell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 8
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(.init(systemName: "star"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.distribution = .fill
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private let horizontalStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.distribution = .fill
        stack.axis = .horizontal
        return stack
    }()

    func update(item: PostItem) {
        titleLabel.text = item.title
        bodyLabel.text = item.body
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(mainStack)
        contentView.clipsToBounds = true
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        horizontalStack.addArrangedSubview(titleLabel)
        horizontalStack.addArrangedSubview(favoriteButton)

        mainStack.addArrangedSubview(horizontalStack)
        mainStack.addArrangedSubview(bodyLabel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostCell {

    #if DEBUG
    var titleLabelValue: String? {
        titleLabel.text
    }
    #endif

}
