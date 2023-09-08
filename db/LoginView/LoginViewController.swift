//
//  LoginViewController.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    private let userId: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "UserID:"
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("LOGIN", for: .normal)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.backgroundColor = .systemBlue
        return button
    }()

    private let userIdText: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = .numberPad
        return textField
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

    private let viewModel = LoginViewModel.make()
    private var subscribers: [AnyCancellable] = []

    var onDismiss: () -> Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(mainStack)
        view.clipsToBounds = true
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true

        horizontalStack.addArrangedSubview(userId)
        horizontalStack.addArrangedSubview(userIdText)

        mainStack.addArrangedSubview(horizontalStack)
        mainStack.addArrangedSubview(errorLabel)
        mainStack.addArrangedSubview(loginButton)

        viewModel.loginError.receive(on: DispatchQueue.main)
            .map { Optional($0) }
            .assign(to: \.text, on: errorLabel)
            .store(in: &subscribers)
        viewModel.loginSuccess.receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] in
                self.dismiss(animated: false)
                self.onDismiss()
            })
            .store(in: &subscribers)

        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        userIdText.becomeFirstResponder()
    }

    @objc
    private func login() {
        viewModel.login(userId: userIdText.text)
    }
}
