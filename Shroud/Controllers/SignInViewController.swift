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
        
        FirebaseAuthService.manager.loginUser(withEmail: email, andPassword: password) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case .success:
                if let parent = self.presentingViewController as? MainControllers,
                    let nav = parent.viewControllers?[0] as? UINavigationController,
                    let friendList = nav.viewControllers[0] as? FriendListViewController{
                    friendList.getFriends()
                }
                self.dismiss(animated: true, completion: nil)
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
