//
//  MessageView.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol MessageViewDelegate: AnyObject {
    func sendPressed(message: Message)
}

class MessageView: UIView {
   
    let messageFormatter = MessageFormatter()
    weak var delegate: MessageViewDelegate?
    
    lazy var messageTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .black
        tv.register(FriendMsgCell.self, forCellReuseIdentifier: "friendCell")
        tv.register(UserMsgCell.self, forCellReuseIdentifier: "userCell")
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    lazy var inputTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .black
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.keyboardAppearance = .dark
        tv.autocorrectionType = .no
        return tv
    }()
    
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var inputContainer: UIView = {
       let tv = UIView()
        tv.backgroundColor = .black
        return tv
    }()
    
    lazy var editingView: EditingView = {
        let view = EditingView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: editingView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addEditView()
        addInputContainer()
        addSendButton()
        addInputView()
        addMessageView()
        backgroundColor = .black
        addActionsToButtons()
    }
    
    
    
    private func addActionsToButtons() {
        editingView.boldText.addTarget(self, action: #selector(boldSelected), for: .touchUpInside)
        editingView.lightText.addTarget(self, action: #selector(lightSelected), for: .touchUpInside)
        editingView.whiteText.addTarget(self, action: #selector(whiteSelected), for: .touchUpInside)
        editingView.redText.addTarget(self, action: #selector(redSelected), for: .touchUpInside)
        editingView.smallText.addTarget(self, action: #selector(smallSelected), for: .touchUpInside)
        editingView.largeText.addTarget(self, action: #selector(largeSelected), for: .touchUpInside)
    }
    
     func setFriendUID(_ friendUID: String) {
        messageFormatter.setFriend(friendUID)
    }
    
    
    @objc private func whiteSelected() {
        if editingView.whiteText.isSelected {
            messageFormatter.setWhiteText()
        } else {
            editingView.whiteText.isSelected.toggle()
            messageFormatter.setWhiteText()
        }
        messageFormatter.updateInput(inputTextView)
        editingView.redText.isSelected = false
    }
    
    
    
    
    @objc private func redSelected() {
        if editingView.redText.isSelected {
            messageFormatter.setRedText()
        } else {
            editingView.redText.isSelected.toggle()
            messageFormatter.setRedText()
        }
        messageFormatter.updateInput(inputTextView)
        editingView.whiteText.isSelected = false
    }
    
    
    
    @objc private func smallSelected() {
        editingView.smallText.isSelected.toggle()
        if editingView.smallText.isSelected {
            messageFormatter.setSmallText()
        } else {
            messageFormatter.setDefaultTextSize()
        }
        messageFormatter.updateInput(inputTextView)
        editingView.largeText.isSelected = false
    }
    
    @objc private func largeSelected() {
        editingView.largeText.isSelected.toggle()
        if editingView.largeText.isSelected {
            messageFormatter.setLargeText()
        } else {
            messageFormatter.setDefaultTextSize()
        }
        messageFormatter.updateInput(inputTextView)
        editingView.smallText.isSelected = false
    }
    
    @objc private func boldSelected() {
        editingView.boldText.isSelected.toggle()
        if editingView.boldText.isSelected {
            messageFormatter.setBoldText()
        } else {
            messageFormatter.setRegText()
        }
        messageFormatter.updateInput(inputTextView)
        editingView.lightText.isSelected = false
    }
    
    @objc private func lightSelected() {
        editingView.lightText.isSelected.toggle()
        if editingView.lightText.isSelected {
            messageFormatter.setLightText()
        } else {
            messageFormatter.setRegText()
        }
        messageFormatter.updateInput(inputTextView)
        editingView.boldText.isSelected = false
    }
    
    private func addEditView() {
        editingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(editingView)
        //editingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomConstraint.isActive = true
        editingView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        editingView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        editingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func addSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(sendButton)
        sendButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -3).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -11).isActive = true

    }
    
    private func addInputView() {
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputTextView)
        inputTextView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor).isActive = true
        inputTextView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor).isActive = true
        inputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor ).isActive = true
        inputContainer.heightAnchor.constraint(equalTo: inputTextView.heightAnchor).isActive = true

    }
    
    
    private func addInputContainer() {
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputContainer)
        inputContainer.bottomAnchor.constraint(equalTo: editingView.topAnchor, constant: -3).isActive = true
        inputContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        inputContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    
    private func addMessageView() {
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageTableView)
        messageTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        messageTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor).isActive = true
    }
    
    
    
    @objc private func sendPressed() {
        guard inputTextView.text.count > 0,
              let messageItem = messageFormatter.createMessage(inputTextView.text) else { return }
        delegate?.sendPressed(message: messageItem)
        inputTextView.text = nil
    }
}
