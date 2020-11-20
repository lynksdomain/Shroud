//
//  FriendListViewController.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit




class FriendListViewController: UIViewController {

    private var currentUser: ShroudUser?
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
        getFriends()
        getUser()
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.navigationBar.topItem?.title = "Shroud"
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(addFriend))
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let profile = UIBarButtonItem(image: UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(openProfile))
        profile.tintColor = .white
        navigationController?.navigationBar.topItem?.leftBarButtonItem = profile
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
    
    func getUser() {
        FirestoreService.manager.getCurrentShroudUser { [weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(user):
                self?.currentUser = user
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
    
    @objc private func openProfile() {
        guard let user = currentUser else { return }
        let profile = ProfileViewController(user)
        profile.modalTransitionStyle = .crossDissolve
        profile.modalPresentationStyle = .overFullScreen
        profile.delegate = self
        present(profile, animated: true, completion: nil)
    }
}


extension FriendListViewController: ProfileViewControllerDelegate {
    func logOut() {
        guard let main = self.tabBarController as? MainControllers,
              let nav = main.navigationController else { return }
        let sign = SignInViewController()
        sign.modalPresentationStyle = .fullScreen
        sign.modalTransitionStyle = .crossDissolve
        sign.modalPresentationCapturesStatusBarAppearance = true
        main.setDelegateToFriendList(sign)
        nav.present(sign, animated: false, completion: nil)
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
        cell.statusLabel.text = user.status
        
        if update.contains(user.uid) {
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .black
        }
        return cell
    }
    
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let currentUser = currentUser else {return}
        let user = friends[indexPath.row]
        if update.contains(user.uid) {
            FirestoreService.manager.updateUnreadMessage(friendUID: user.uid) { (result) in
            }
        }
        let msgView = MessageViewController(friend: user, currentUN: currentUser.username)
            navigationController?.pushViewController(msgView, animated: true)
    }
    
}



extension FriendListViewController: SignInViewControllerDelegate {
    func loggedIn() {
        getFriends()
        getUser()
        dismiss(animated: true, completion: nil)
    }
    
    func newUserCreated() {
        getFriends()
        getUser()
        dismiss(animated: true, completion: nil)
    }
    
}
