//
//  SignInView.swift
//  Shroud
//
//  Created by Lynk on 9/4/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol SignInDelegate: AnyObject {
    func signUpPressed()
    func logInPressed(email: String? , password: String?)
}


class SignInView: UIView {
    
    weak var delegate: SignInDelegate?
    
    lazy var signUpButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(SignUpPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var logInButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var shroudLogo: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "logo.png")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    lazy var emailTextField: UITextField = {
        var tf = CustomTextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
       var tf = CustomTextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit () {
        backgroundColor = .black
        addLogo()
        addEmailTextField()
        addPasswordTextField()
        addStackButtons()
    }
    
    private func addLogo() {
        shroudLogo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shroudLogo)
        shroudLogo.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        shroudLogo.heightAnchor.constraint(equalTo: shroudLogo.widthAnchor, multiplier: 0.5).isActive = true
        shroudLogo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        NSLayoutConstraint.activate([NSLayoutConstraint(item: shroudLogo, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.55, constant: 0)])
    }
    
    private func addEmailTextField() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emailTextField)
        emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        emailTextField.topAnchor.constraint(equalTo: shroudLogo.bottomAnchor, constant: 22).isActive = true
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
    
   
    
    private func addStackButtons() {
        let stack = UIStackView(arrangedSubviews: [signUpButton,logInButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22).isActive = true
        stack.spacing = 22
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc private func logInPressed() {
        delegate?.logInPressed(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc private func SignUpPressed() {
        delegate?.signUpPressed()
      }
      
}


class CustomTextField: UITextField {
    struct Constants {
        static let sidePadding: CGFloat = 10
        static let topPadding: CGFloat = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        attributedPlaceholder = NSAttributedString(string: "a",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        keyboardAppearance = .dark
        textColor = .white
        backgroundColor = ShroudColors.darkGray
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}
