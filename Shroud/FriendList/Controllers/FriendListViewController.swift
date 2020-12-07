//
//  FriendListViewController.swift
//  Shroud
//
//  Created by Lynk on 9/9/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit
import Kingfisher



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
        cell.avatar.kf.indicatorType = .activity
        cell.avatar.kf.setImage(with: URL(string: user.profilePicture))
        
        if update.contains(user.uid) {
            cell.notificationView.isHidden = false
        } else {
            cell.notificationView.isHidden = true
        }
        return cell
    }
    
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let currentUser = currentUser else {return}
        let user = friends[indexPath.row]
        if update.contains(user.uid) {
            FirestoreService.manager.updateUnreadMessage(friendUID: user.uid) { (result) in
            }
        }
        let msgView = MessageViewController(friend: user, currentUN: currentUser.username)
            navigationController?.pushViewController(msgView, animated: true)
    }
    
    func deleteFriendPrompt(row:Int) {
        //alert to delete friend
        let prompt = UIAlertController(title: "Do you want to delete this friend?", message: "You will also be removed from their list", preferredStyle: .alert)
        prompt.overrideUserInterfaceStyle = .dark
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            guard let current = self.currentUser else { return }
            FirestoreService.manager.deleteFriend(current.uid, self.friends[row].uid)
        }
        prompt.addAction(cancel)
        prompt.addAction(delete)
        present(prompt, animated: true, completion: nil)
    }
    
    func blockFriendPrompt(row:Int) {
        //alert to block friend
        let prompt = UIAlertController(title: "Do you want to block this friend?", message: "They will not be able to add you again until you unblock them", preferredStyle: .alert)
        prompt.overrideUserInterfaceStyle = .dark
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let block = UIAlertAction(title: "Block", style: .destructive) { (alert) in
            guard let current = self.currentUser else { return }
            FirestoreService.manager.blockFriend(current.uid, self.friends[row])
        }
        prompt.addAction(cancel)
        prompt.addAction(block)
        present(prompt, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteFriend = UIContextualAction(style: .destructive, title: "Remove  Friend") { [weak self](action, view, completion) in
            self?.deleteFriendPrompt(row: indexPath.row)
            completion(true)
        }
        deleteFriend.backgroundColor = ShroudColors.userBlue

        let block = UIContextualAction(style: .destructive, title: "Block") { [weak self](action, view, completion) in
            self?.blockFriendPrompt(row: indexPath.row)
            completion(true)
        }
        block.backgroundColor = ShroudColors.friendRed
        let swipe = UISwipeActionsConfiguration(actions: [block, deleteFriend])
        swipe.performsFirstActionWithFullSwipe = false
        
        return swipe
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
