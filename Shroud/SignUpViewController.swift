//
//  SignUpViewController.swift
//  Shroud
//
//  Created by Lynk on 9/7/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit
import FirebaseAuth



class SignUpViewController: UIViewController {
    
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
        guard let username = username else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.signUpView.showError(error: error.localizedDescription)
                }
                
            
            
            if let result = result {
                print("done")
            }
        }

    }

    
    
}
