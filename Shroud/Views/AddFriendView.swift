//
//  AddFriendView.swift
//  Shroud
//
//  Created by Lynk on 9/10/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol AddFriendViewDelegate: AnyObject {
    func dismissPressed()
    func addFriendPressed(username: String?)
}

class AddFriendView: UIView {
    
    weak var delegate: AddFriendViewDelegate?
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var addFriendButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Add Friend", for: .normal)
        button.addTarget(self, action: #selector(addFriendPressed), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    lazy var prompt: UILabel = {
        var label = UILabel()
               label.text = "Add Friend"
               label.textColor = .white
               label.font = UIFont.systemFont(ofSize: 34)
               label.textAlignment = .center
               return label
    }()
    
    lazy var usernameTextField: UITextField = {
        var tf = CustomTextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.placeholder = "Username"
        return tf
    }()
    
    lazy var errorDisplay: UILabel = {
       var label = UILabel()
        label.text = ""
          label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addDismissButton()
        addPrompt()
        addUsernameTextField()
        addfriendButton()
        addErrorDisplay()
        backgroundColor = .black
    }
    
    @objc private func dismiss() {
        delegate?.dismissPressed()
    }
    
    @objc private func addFriendPressed() {
        delegate?.addFriendPressed(username: usernameTextField.text)
    }
    
    private func addDismissButton() {
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11).isActive = true
        dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    }
    
    private func addPrompt() {
        prompt.translatesAutoresizingMaskIntoConstraints = false
        addSubview(prompt)
        prompt.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 11).isActive = true
        prompt.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func addUsernameTextField() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: prompt.bottomAnchor, constant: 22).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func addfriendButton() {
           addFriendButton.translatesAutoresizingMaskIntoConstraints = false
           addSubview(addFriendButton)
           addFriendButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
           addFriendButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65).isActive = true
           addFriendButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 22).isActive = true
           addFriendButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
       }
    
    
    private func addErrorDisplay() {
        errorDisplay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorDisplay)
        errorDisplay.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        errorDisplay.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 11).isActive = true
    }
    
    func showError(error: String) {
        errorDisplay.text = error
    }
}
