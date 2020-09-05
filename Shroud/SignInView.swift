//
//  SignInView.swift
//  Shroud
//
//  Created by Lynk on 9/4/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class SignInView: UIView {
    lazy var shroudLogo: UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var emailTextField: UITextField = {
        var tf = CustomTextField()
        tf.placeholder = "Email"
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
       var tf = CustomTextField()
        tf.placeholder = "Password"
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
        backgroundColor = .white
        shroudLogo.image = UIImage(named: "logo.png")
        addLogo()
        addEmailTextField()
        addPasswordTextField()
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
        emailTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        emailTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    
    private func addPasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(passwordTextField)
        passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 11).isActive = true
        passwordTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        passwordTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
}


class CustomTextField: UITextField {
    struct Constants {
        static let sidePadding: CGFloat = 10
        static let topPadding: CGFloat = 8
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
