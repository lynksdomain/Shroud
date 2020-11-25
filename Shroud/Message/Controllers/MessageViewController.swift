//
//  MessageViewController.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Kingfisher


class MessageViewController: UIViewController {
    
    var friend: ShroudUser!
    var currentUN: String!
    lazy var messageView = MessageView()
    var messageFormatter = MessageFormatter()
    let heading = HeadingMsgView()
    
    var status = "" {
        didSet {
            DispatchQueue.main.async {
                self.heading.statusLabel.text = self.status
            }
        }
    }
    
    
    var messages = [Message]() {
        didSet {
            updateMessages()
            DispatchQueue.main.async {
                self.messageView.messageTableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    init(friend: ShroudUser, currentUN: String) {
        super.init(nibName: nil, bundle: nil)
        self.friend = friend
        self.currentUN = currentUN
        messageView.setFriendUID(friend.uid)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.delegate = self
        messageView.messageTableView.dataSource = self
        messageView.messageTableView.delegate = self
        messageView.messageTableView.rowHeight = UITableView.automaticDimension
        messageView.messageTableView.estimatedRowHeight = 600
        view.addSubview(messageView)
        setView()
        getMessage()
        getStatus()
        navigationItem.titleView = heading
        heading.userLabel.text = friend.username
        heading.statusLabel.text = friend.status
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func scrollToBottom() {
        if self.messages.count > 0 {
            self.messageView.messageTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    private func updateMessages() {
        FirestoreService.manager.updateUnreadMessage(friendUID: friend.uid) { (result) in
            
        }
    }
    
    
    private func getStatus() {
        FirestoreService.manager.fetchStatus(friendUID: friend.uid) {[weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(status):
                self?.status = status
            }
        }
    }
    
    
    private func getMessage() {
        FirestoreService.manager.fetchConversation(friendUID: friend.uid) {[weak self] (result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(messages):
                self?.messages = messages
            }
        }
    }
    
  
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.messageView.bottomConstraint.constant = -(keyboardFrame.size.height + 5)
            self.view.layoutIfNeeded()
            self.scrollToBottom()
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
    
    func mmsSend(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        FirebaseStorageService.manager.sendImage(picture: data) {[weak self] (result) in
            switch result {
            case let .success(url):
                guard let currentUser = FirebaseAuthService.manager.currentUser,
                      let friendUID = self?.friend.uid else { return }
                let message = Message(url.absoluteString, currentUser.uid , users: [currentUser.uid,friendUID], read: false, timestamp: Timestamp(date: Date()))
                FirestoreService.manager.sendMessage(friendUID, message) { (result) in
                    switch result {
                    case .success():
                        print("success")
                    case let .failure(error):
                        print(error)
                    }
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func mmsPreview(image: UIImage) {
        let preview = ImagePreviewViewController(image: image)
        let nav = UINavigationController(rootViewController: preview)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func mmsPressed() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.overrideUserInterfaceStyle = .dark
        present(pickerController, animated: true, completion: nil)
    }
    
    @available(iOS 14.0, *)
    func colorPickerPressed() {
        let colorPicker = UIColorPickerViewController()
        colorPicker.selectedColor = .white
        colorPicker.supportsAlpha = false
        colorPicker.overrideUserInterfaceStyle = .dark
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    func sendPressed(message: Message) {
        FirestoreService.manager.sendMessage(friend.uid, message) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case .success():
                print("message sent")
            }
        }
    }
}

extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.messageView.setMmsImage(image: image)
    
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.messageView.mmsHeightConstraint.constant = 100
            self.messageView.layoutIfNeeded()
            self.scrollToBottom()
            })
        
        picker.dismiss(animated: true, completion: nil)
    }
}


@available(iOS 14.0, *)
extension MessageViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        messageView.customColorSelected(color: viewController.selectedColor)
    }
}



extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageItem = messages[indexPath.row]
        
        if messageItem.messageType == .text {
            if friend.uid == messageItem.authorUID {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? FriendMsgCell else { return UITableViewCell() }
                cell.setFormatting(message: messageItem, sender: friend.username)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserMsgCell,
                      let currentUN = currentUN else { return UITableViewCell() }
                cell.setFormatting(message: messageItem, sender: currentUN)
                return cell
            }
        } else {
            
            if friend.uid == messageItem.authorUID {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendImgCell", for: indexPath) as? FriendImgCell,
                      let stringURL = messageItem.imageURL else { return UITableViewCell() }
                cell.pictureView.kf.indicatorType = .activity
                cell.pictureView.kf.setImage(with: URL(string: stringURL))
                cell.tap.addTarget(self, action: #selector(previewSelected(sender:)))
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "userImgCell", for: indexPath) as? UserImgCell,
                      let stringURL = messageItem.imageURL else { return UITableViewCell() }
                cell.pictureView.kf.indicatorType = .activity
                cell.pictureView.kf.setImage(with: URL(string: stringURL))
                cell.tap.addTarget(self, action: #selector(previewSelected(sender:)))
                return cell
            }
        }
    }
    
    
    @objc private func previewSelected(sender: UITapGestureRecognizer) {
        guard let pictureView = sender.view as? UIImageView,
              let image = pictureView.image else { return }
        let preview = ImagePreviewViewController(image: image)
        let nav = UINavigationController(rootViewController: preview)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}
