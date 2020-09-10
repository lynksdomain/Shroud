//
//  SignUpView.swift
//  Shroud
//
//  Created by Lynk on 9/7/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {
    func signUpPressed(email:String?,password:String?,username:String?)
}


class SignUpView: UIView {
    
    weak var delegate: SignUpViewDelegate?
    
    lazy var emailTextField: UITextField = {
        var tf = CustomTextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    lazy var SignUpButton: UIButton = {
           var button = UIButton(type: .system)
           button.setTitleColor(.white, for: .normal)
           button.setTitle("Sign Up", for: .normal)
           button.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)
        button.backgroundColor = .systemBlue
           return button
       }()
    
    lazy var passwordTextField: UITextField = {
        var tf = CustomTextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var usernameTextField: UITextField = {
        var tf = CustomTextField()
        tf.placeholder = "Username"
        return tf
    }()
    
    lazy var notice: UILabel = {
       var label = UILabel()
        label.text = "Do not use your real name for your username."
          label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var errorDisplay: UILabel = {
       var label = UILabel()
        label.text = ""
          label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemRed
        return label
    }()
    
    lazy var title: UILabel = {
       var label = UILabel()
        label.text = "Create Account"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34)
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
        backgroundColor = .black
        addTitle()
        addNotice()
        addEmailTextField()
        addPasswordTextField()
        addUsernameTextField()
        addSignUpButton()
        addErrorDisplay()
    }
    
    @objc private func signUpPressed() {
        delegate?.signUpPressed(email: emailTextField.text, password: passwordTextField.text, username: usernameTextField.text)
    }
    
    func showError(error: String) {
        errorDisplay.text = error
    }
    
    private func addTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        title.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 33).isActive = true
    }
    
    
    private func addNotice() {
           notice.translatesAutoresizingMaskIntoConstraints = false
           addSubview(notice)
           notice.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
           notice.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 11).isActive = true
       }
    
    private func addEmailTextField() {
           emailTextField.translatesAutoresizingMaskIntoConstraints = false
           addSubview(emailTextField)
           emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
           emailTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
           emailTextField.topAnchor.constraint(equalTo: notice.bottomAnchor, constant: 22).isActive = true
           emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
       }
       
       
       private func addPasswordTextField() {
           passwordTextField.translatesAutoresizingMaskIntoConstraints = false
           addSubview(passwordTextField)
           passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
           passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
           passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 11).isActive = true
           passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
       }
    
    private func addUsernameTextField() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(usernameTextField)
        usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 11).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func addSignUpButton() {
        SignUpButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(SignUpButton)
        SignUpButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        SignUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        SignUpButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 11).isActive = true
        SignUpButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    private func addErrorDisplay() {
        errorDisplay.translatesAutoresizingMaskIntoConstraints = false
        addSubview(errorDisplay)
        errorDisplay.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        errorDisplay.topAnchor.constraint(equalTo: SignUpButton.bottomAnchor, constant: 11).isActive = true
    }
}
