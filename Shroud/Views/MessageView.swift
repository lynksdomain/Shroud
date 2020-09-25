//
//  MessageView.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol MessageViewDelegate: AnyObject {
    func sendPressed(message: String)
}

class MessageView: UIView {
   
    weak var delegate: MessageViewDelegate?
    
    lazy var messageTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .black
        tv.register(MessageCell.self, forCellReuseIdentifier: "msgCell")
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
    
    lazy var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: editingView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
    
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
        delegate?.sendPressed(message: inputTextView.text)
        inputTextView.text = nil
    }
}
