//
//  BlockedViewController.swift
//  Shroud
//
//  Created by Lynk on 12/2/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class BlockedViewController: UIViewController {

    
    var blockedUsers = [ShroudUser]() {
        didSet {
            blocked.blockedTableView.reloadData()
        }
    }
        
    let blocked = BlockedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blocked)
        blocked.blockedTableView.dataSource = self
        blocked.blockedTableView.delegate = self
        fetchBlockedUsers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        navigationController?.navigationBar.topItem?.title = "Blocked Users"
    }
    
    func fetchBlockedUsers() {
        FirestoreService.manager.fetchBlockedUsers {[weak self] (result) in
            switch result {
            case let .success(users):
                DispatchQueue.main.async {
                    self?.blockedUsers = users
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
}


extension BlockedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as? BlockedCell else { return UITableViewCell() }
        let user = blockedUsers[indexPath.row]
        cell.unblockButton.addTarget(self, action: #selector(unblock(sender:)), for: .touchUpInside)
        cell.unblockButton.tag = indexPath.row
        cell.configureCell(user: user)
        return cell
    }
    
    @objc func unblock(sender: UIButton) {
        let alert = UIAlertController(title: "You are about to unblock this user", message: "You still need to re-add them as a friend to communicate", preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .dark
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let unblock = UIAlertAction(title: "Unblock", style: .default) { (alert) in
            let row = sender.tag
            let user = self.blockedUsers[row]
            FirestoreService.manager.unblockUser(friendUID: user.uid) { (result) in
                switch result {
                case .success():
                    print("success")
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(unblock)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
