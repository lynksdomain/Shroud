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
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
