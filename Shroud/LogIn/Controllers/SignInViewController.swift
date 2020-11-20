//
//  SignInViewController.swift
//  Shroud
//
//  Created by Lynk on 9/4/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol SignInViewControllerDelegate: AnyObject {
    func newUserCreated()
    func loggedIn()
}

class SignInViewController: UIViewController {
    let signInView = SignInView()
    weak var delegate: SignInViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInView)
        signInView.delegate = self
    }
    
}



extension SignInViewController: SignInDelegate {
    func logInPressed(email: String?, password: String?) {
        guard let email = email else { return }
        guard let password = password else { return }
        
        FirebaseAuthService.manager.loginUser(withEmail: email, andPassword: password) { [weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case .success:
                self?.delegate?.loggedIn()
                }
            }
        }
    
    
    func signUpPressed() {
        let signUp = SignUpViewController()
        signUp.modalTransitionStyle = .crossDissolve
        signUp.modalPresentationStyle = .fullScreen
        signUp.delegate = self
        present(signUp, animated: true, completion: nil)
    }
}


extension SignInViewController: SignUpViewControllerDelegate {
    func newUserCreated() {
        delegate?.newUserCreated()
    }
}
