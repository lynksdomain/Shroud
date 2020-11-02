//
//  ProfileViewController.swift
//  Shroud
//
//  Created by Lynk on 10/12/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit




class ProfileViewController: UIViewController {

    let profileView = ProfileView()
    var user: ShroudUser!
    
    
    init(_ user: ShroudUser) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        profileView.tap.addTarget(self, action: #selector(dismissVC))
        profileView.editPhoto.addTarget(self, action: #selector(editPhoto))
        profileView.editStatus.addTarget(self, action: #selector(editStatus), for: .touchUpInside)
        profileView.usernameLabel.text = user.username
        profileView.statusField.text = user.status
    }
    
    
    
    @objc func editPhoto() {
        print("photos")
    }
    
    @objc func editStatus() {
        guard let text = profileView.statusField.text else { return }
        let vc = EditStatusViewController(status: text)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
}


extension ProfileViewController: EditStatusControllerDelegate {
    func setStatus(_ status: String) {
        profileView.statusField.text = status
    }
}
