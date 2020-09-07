//
//  SignInViewController.swift
//  Shroud
//
//  Created by Lynk on 9/4/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    let signInView = SignInView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInView)
        signInView.delegate = self
    }
    

}

extension SignInViewController: SignInDelegate {
    func signUpPressed() {
        present(SignUpViewController(), animated: true, completion: nil)
    }
    
    func logInPressed() {
        print("logIn")
    }
    
    
}
