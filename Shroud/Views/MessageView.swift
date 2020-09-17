//
//  MessageView.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit


class MessageView: UIView {
   
    lazy var messageTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .black
        tv.register(MessageCell.self, forCellReuseIdentifier: "msgCell")
        return tv
    }()
    
    lazy var inputTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .black
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    }()
    
    lazy var editingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
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
        addInputView()
        addMessageView()
    }
    
    
    
    
    private func addEditView() {
        editingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(editingView)
        editingView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        editingView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        editingView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        editingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func addInputView() {
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputTextView)
        inputTextView.bottomAnchor.constraint(equalTo: editingView.topAnchor).isActive = true
        inputTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        inputTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    }
    
    
    private func addMessageView() {
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageTableView)
        messageTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        messageTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor).isActive = true
    }
    
    
}
