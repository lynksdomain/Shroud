//
//  ProfileViewController.swift
//  Shroud
//
//  Created by Lynk on 10/12/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit
import Kingfisher


protocol ProfileViewControllerDelegate: AnyObject {
    func logOut()
}


class ProfileViewController: UIViewController {

    let profileView = ProfileView()
    var user: ShroudUser!
    var delegate: ProfileViewControllerDelegate?
    
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
        profileView.logOut.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        profileView.usernameLabel.text = user.username
        profileView.statusField.text = user.status
        profileView.profileImage.kf.indicatorType = .activity
        profileView.profileImage.kf.setImage(with: URL(string: user.profilePicture))
    }
    
    
    @objc func logOut() {
        if FirebaseAuthService.manager.signOut() {
        dismiss(animated: false) {
            self.delegate?.logOut()
        }
        }
    }
    
    
    @objc func editPhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.overrideUserInterfaceStyle = .dark
        
        if Default.hasSetUserPhoto() {
            present(pickerController, animated: true, completion: nil)
        } else {
            let prompt = UIAlertController(title: "Notice", message: "We strongly recommend using a picture of an avatar and not a personal picture!", preferredStyle: .alert)
            prompt.overrideUserInterfaceStyle = .dark
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                Default.setFirstTimeUserPhoto()
                self.present(pickerController, animated: true, completion: nil)
            }
            prompt.addAction(okAction)
            present(prompt, animated: true, completion: nil)
        }
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


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 1.0) else { return }
        FirebaseStorageService.manager.addProfileImage(user: user, profilePicture: data) {[weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(url):
                self?.profileView.profileImage.kf.setImage(with: url)
            }
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
