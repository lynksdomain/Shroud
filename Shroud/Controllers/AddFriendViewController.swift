//
//  AddFriendViewController.swift
//  Shroud
//
//  Created by Lynk on 9/10/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit




class AddFriendViewController: UIViewController {

    let addFriendView = AddFriendView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(addFriendView)
        addFriendView.delegate = self
    }
    

}


extension AddFriendViewController: AddFriendViewDelegate {
    func addFriendPressed(username: String?) {
        guard let username = username else {
            addFriendView.showError(error: "Invalid Username")
            return
        }
        FirestoreService.manager.addFriend(username) { (result) in
            switch result {
            case .success:
                self.dismiss(animated: true, completion: nil)
            case let .failure(error):
                self.addFriendView.showError(error: error.localizedDescription)
            }
        }
    }
    
    func dismissPressed() {
        dismiss(animated: true, completion: nil)
    }
}
