//
//  FriendListViewController.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    private var friendListView = FriendListView()
    private var friends = [ShroudUser]() {
        didSet {
            DispatchQueue.main.async {
                self.friendListView.friendListTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getFriends()
    }
    
    
    private func setUp() {
        view.addSubview(friendListView)
        friendListView.friendListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
               friendListView.friendListTableView.delegate = self
               friendListView.friendListTableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }
    
    
    private func getFriends() {
        
        FirestoreService.manager.fetchFriends { (result) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(friends):
                self.friends = friends
            }
        }
        
        
    }
    
    
    @objc private func addFriend() {
        let add = AddFriendViewController()
        add.modalPresentationStyle = .fullScreen
        present(add, animated: true, completion: nil)
    }
}


extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListCell else { return UITableViewCell()}
        cell.nameLabel.text = friends[indexPath.row].username
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}
