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
    func mmsPreview(image: UIImage)
    func mmsSend(image:UIImage)
    func mmsPressed()
    @available(iOS 14.0, *)
    func colorPickerPressed()
}

class MessageView: UIView {
   
    let messageFormatter = MessageFormatter()
    
    
    weak var delegate: MessageViewDelegate?
    
    lazy var messageTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = .black
        tv.register(FriendImgCell.self, forCellReuseIdentifier: "friendImgCell")
        tv.register(UserImgCell.self, forCellReuseIdentifier: "userImgCell")
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
    
    lazy var mmsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(mmsPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var mmsImageView: MmsImageView = {
        let view = MmsImageView(frame: CGRect.zero)
        view.cancelButton.addTarget(self, action: #selector(mmsCanceled), for: .touchUpInside)
        view.pictureTap.addTarget(self, action: #selector(mmsPreview))
        return view
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
    
    lazy var mmsContainer: UIView = {
        let tv = UIView()
        tv.backgroundColor = .black
        tv.layer.borderWidth = 0.3
        tv.layer.borderColor = UIColor.lightGray.cgColor
        return tv
    }()
    
    lazy var mmsHeightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: mmsContainer, attribute: .height, relatedBy: .equal, toItem: mmsContainer, attribute: .height, multiplier: 0, constant: 0)
    
    
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
        addMmsButton()
        addSendButton()
        addInputView()
        addMmsContainer()
        addMmsImageView()
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
    
    func setMmsImage(image: UIImage) {
        mmsImageView.image = image
    }
    
    @objc private func mmsCanceled() {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.mmsHeightConstraint.constant = 0
            self.layoutIfNeeded()
            self.mmsImageView.image = nil
            })
    }
    
    @objc private func mmsPreview() {
        guard let image = mmsImageView.image else { return }
        delegate?.mmsPreview(image: image )
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
        
        if #available(iOS 14.0, *) {
            delegate?.colorPickerPressed()
        } else {
            if !editingView.redText.isSelected {
                editingView.redText.isSelected.toggle()
            }
            
            messageFormatter.setColorText(color: .red)
            messageFormatter.updateInput(inputTextView)
            editingView.whiteText.isSelected = false
        }
    }
    
     func customColorSelected(color: UIColor) {
        if !editingView.redText.isSelected {
            editingView.redText.isSelected.toggle()
        }
        
        editingView.redText.setTitleColor(color, for: .normal)
        messageFormatter.setColorText(color: color)
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
    
    private func addMmsButton() {
        mmsButton.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(mmsButton)
        mmsButton.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -3).isActive = true
        mmsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        mmsButton.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 11).isActive = true

    }
    
    
    private func addInputView() {
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputTextView)
        inputTextView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor).isActive = true
        inputTextView.leadingAnchor.constraint(equalTo: mmsButton.trailingAnchor,constant: 5).isActive = true
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
    
    private func addMmsContainer() {
        mmsContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mmsContainer)
        mmsContainer.bottomAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        mmsContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mmsContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mmsHeightConstraint.isActive = true
    }
    
    private func addMmsImageView() {
        mmsImageView.translatesAutoresizingMaskIntoConstraints = false
        mmsContainer.addSubview(mmsImageView)
        mmsImageView.topAnchor.constraint(equalTo: mmsContainer.topAnchor, constant: 5).isActive = true
        mmsImageView.bottomAnchor.constraint(equalTo: mmsContainer.bottomAnchor, constant: -5).isActive = true
        mmsImageView.widthAnchor.constraint(equalTo: mmsImageView.heightAnchor).isActive = true
        mmsImageView.leadingAnchor.constraint(equalTo: inputTextView.leadingAnchor).isActive = true
    }
    
    
    private func addMessageView() {
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageTableView)
        messageTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        messageTableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        messageTableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        messageTableView.bottomAnchor.constraint(equalTo: mmsContainer.topAnchor).isActive = true
    }
    @objc private func mmsPressed() {
        delegate?.mmsPressed()
    }
    
    
    @objc private func sendPressed() {
        
        if let image = mmsImageView.image {
            delegate?.mmsSend(image: image)
            mmsCanceled()
        }
        
        
        
        guard inputTextView.text.count > 0,
              let messageItem = messageFormatter.createMessage(inputTextView.text) else { return }
        delegate?.sendPressed(message: messageItem)
        inputTextView.text = nil
    }
}
