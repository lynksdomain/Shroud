//
//  FriendListViewController.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    var friendListView = FriendListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendListView)
        friendListView.friendListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        friendListView.friendListTableView.delegate = self
        friendListView.friendListTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }
    
    @objc private func addFriend() {
        let add = AddFriendViewController()
        add.modalPresentationStyle = .fullScreen
        present(add, animated: true, completion: nil)
    }
}


extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListCell else { return UITableViewCell()}
        return cell
    }
    
    
    
    
    
}
