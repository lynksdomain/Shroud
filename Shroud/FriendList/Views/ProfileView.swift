//
//  ProfileView.swift
//  Shroud
//
//  Created by Lynk on 10/12/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit


class ProfileView: ProgrammaticView {
    
    lazy var transparencyView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //blurEffectView.alpha = 0.8
        return blurEffectView
    }()
    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    
    lazy var editPhoto: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        return tap
    }()
    
    lazy var profileImage: UIImageView = {
        var image = UIImageView()
        image.backgroundColor = .lightGray
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var menuView: UIView = {
        var view = UIView()
        view.backgroundColor = ShroudColors.darkGray
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
       let label = UILabel()
        label.text = "Username"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var editStatus: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Edit Status", for: .normal)
        button.backgroundColor = ShroudColors.userBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    lazy var logOut: UIButton = {
       let button = UIButton(type: .roundedRect)
        button.setTitle("Log Out", for: .normal)
        button.backgroundColor = ShroudColors.friendRed
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    lazy var statusField: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 13, weight: .light)
        view.textColor = .white
        view.numberOfLines = 0
        view.text = "This is a status"
        return view
    }()
    
    override func commonInit() {
        addSubview(transparencyView)
        addSubview(menuView)
        addSubview(profileImage)
        menuView.addSubview(usernameLabel)
        menuView.addSubview(statusField)
        menuView.addSubview(editStatus)
        menuView.addSubview(logOut)
        editStatus.translatesAutoresizingMaskIntoConstraints = false
        statusField.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        transparencyView.addGestureRecognizer(tap)
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        transparencyView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        logOut.translatesAutoresizingMaskIntoConstraints = false
        transparencyConstraints()
        menuConstraints()
        profileConstraints()
        usernameConstraints()
        statusConstraints()
        editStatusConstraints()
        logoutConstraints()
        transparencyView.addGestureRecognizer(tap)
        profileImage.addGestureRecognizer(editPhoto)
    }
    
    private func logoutConstraints() {
        NSLayoutConstraint.activate([logOut.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant:  -20),
                                     logOut.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant:  20),
                                     logOut.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant:  -20),
                                     logOut.heightAnchor.constraint(equalToConstant: 25)])
    }
    
    private func editStatusConstraints() {
        NSLayoutConstraint.activate([editStatus.bottomAnchor.constraint(equalTo: logOut.topAnchor, constant:  -11),
                                     editStatus.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant:  20),
                                     editStatus.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant:  -20),
                                     editStatus.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant:  20),
                                     editStatus.heightAnchor.constraint(equalTo: logOut.heightAnchor)])
    }
    
    
    private func transparencyConstraints() {
        NSLayoutConstraint.activate([transparencyView.topAnchor.constraint(equalTo: topAnchor),
                                     transparencyView.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     transparencyView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     transparencyView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
    
    private func statusConstraints() {
        NSLayoutConstraint.activate([statusField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 0),
                                     statusField.leadingAnchor.constraint(equalTo: menuView.leadingAnchor,constant: 20),
                                     statusField.trailingAnchor.constraint(equalTo: menuView.trailingAnchor,constant: -20)])
    }
    
    
    private func usernameConstraints() {
        NSLayoutConstraint.activate([usernameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0),
                                     usernameLabel.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
                                     usernameLabel.trailingAnchor.constraint(equalTo: menuView.trailingAnchor)])
    }
    
    private func menuConstraints() {
        NSLayoutConstraint.activate([menuView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                                     menuView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     menuView.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
    private func profileConstraints() {
        NSLayoutConstraint.activate([profileImage.heightAnchor.constraint(equalToConstant: 120),
                                     profileImage.widthAnchor.constraint(equalToConstant: 120),
                                     profileImage.centerYAnchor.constraint(equalTo: menuView.topAnchor),
                                     profileImage.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
    func setBorders() {
        profileImage.layer.borderWidth = 8
        profileImage.layer.borderColor = ShroudColors.darkGray.cgColor
        menuView.layer.cornerRadius = 20
        menuView.layer.cornerCurve = .continuous
        profileImage.layer.cornerCurve = .circular
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        editStatus.layer.cornerRadius = 5
        editStatus.layer.cornerCurve = .continuous
        logOut.layer.cornerRadius = 5
        logOut.layer.cornerCurve = .continuous
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBorders()
    }
}
