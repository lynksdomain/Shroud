//
//  SignUpViewController.swift
//  Shroud
//
//  Created by Lynk on 9/7/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func newUserCreated()
}


class SignUpViewController: UIViewController {
    
    weak var delegate: SignUpViewControllerDelegate?
    var signUpView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signUpView)
        signUpView.delegate = self
    }
    

}

extension SignUpViewController: SignUpViewDelegate {
    func signUpPressed(email: String?, password: String?, username: String?) {
        guard let email = email else {return}
        guard let password = password else {return}
        guard let username = username,
            username.count > 5 else {
            signUpView.showError(error: "Username must  have more than 5 characters")
            return
        }
        
        FirebaseAuthService.manager.createNewUser(email, password, username) { [weak self](result) in
            switch result {
            case let .success(user):
                let shroudUser = ShroudUser(from: user, username: username, status: "No Status")
                self?.userToFirestore(shroudUser)
            case let .failure(error):
                self?.signUpView.showError(error: error.localizedDescription)
                }
            }
        }
    
    private func userToFirestore(_ user: ShroudUser) {
        FirestoreService.manager.create(user) { [weak self](result) in
            switch result {
            case .success():
                self?.delegate?.newUserCreated()
            case let .failure(error):
                self?.signUpView.showError(error: error.localizedDescription)
            }
        }
    }
    
    }

    
    

