//
//  MessageViewController.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    var friendUID: String!
    lazy var messageView = MessageView()
    
    var messages = [Message]() {
        didSet {
            DispatchQueue.main.async {
                self.messageView.messageTableView.reloadData()
            }
        }
    }
    
    init(friendUID: String) {
        super.init(nibName: nil, bundle: nil)
        self.friendUID = friendUID
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.friendUID = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.delegate = self
        messageView.messageTableView.dataSource = self
        view.addSubview(messageView)
        setView()
        getMessage()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    
    private func getMessage() {
        FirestoreService.manager.fetchConversation(friendUID: friendUID) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(messages):
                self.messages = messages
            }
        }
    }
    
  
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.messageView.bottomConstraint.constant = -(keyboardFrame.size.height + 20)
            self.view.layoutIfNeeded()
            })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.messageView.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
            })
    }
    
    
    func setView() {
        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    
    override func viewDidLayoutSubviews() {
        messageView.setNeedsLayout()
        messageView.layoutIfNeeded()
        messageView.inputContainer.addBorder(toSide: .Top, withColor: UIColor.lightGray.withAlphaComponent(0.5).cgColor, andThickness: 0.3)

       
    }

}

extension MessageViewController: MessageViewDelegate {
    func sendPressed(message: String) {
        guard message.count > 0 else { return }
        
    }
}


extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let msg = messages[indexPath.row].message
        cell.textLabel?.text = msg
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    
    
    
    
}
