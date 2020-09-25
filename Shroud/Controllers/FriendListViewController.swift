//
//  FriendListViewController.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    private var loaded = false
    private var friendListView = FriendListView()
    private var friends = [ShroudUser]() {
        didSet {
            DispatchQueue.main.async {
                self.friendListView.friendListTableView.reloadData()
            }
        }
    }
    
    private var update = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.friendListView.friendListTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard loaded else {
        navigationController?.navigationBar.topItem?.title = "Shroud"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            getFriends()
            loaded.toggle()
            return
        }

    }
    
    private func setUp() {
        view.addSubview(friendListView)
        friendListView.friendListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        friendListView.friendListTableView.delegate = self
        friendListView.friendListTableView.dataSource = self
        
    }
    
     func getFriends() {
        FirestoreService.manager.fetchFriends { (result) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(friends):
                self.friends = friends
                self.getMessages()
            }
        }
        
        
    }
    
    
    func getMessages() {
        FirestoreService.manager.fetchUnreadMessages { (result) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(messages):
                self.update = messages.map{ $0.authorUID }
            }
        }
    }
    
    @objc private func addFriend() {
        let add = AddFriendViewController()
        add.modalPresentationStyle = .overFullScreen
        present(add, animated: true, completion: nil)
    }
}


extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListCell else { return UITableViewCell()}
        let user = friends[indexPath.row]
        cell.nameLabel.text = user.username
        if update.contains(user.uid) {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .black
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = friends[indexPath.row]
        if update.contains(user.uid) {
            FirestoreService.manager.updateUnreadMessage(friendUID: user.uid) { (result) in
            }
        }
            let msgView = MessageViewController(friendUID: user.uid)
            navigationController?.pushViewController(msgView, animated: true)
    }
    
}
