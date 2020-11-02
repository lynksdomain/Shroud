//
//  EditStatusViewController.swift
//  Shroud
//
//  Created by Lynk on 10/13/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

protocol EditStatusControllerDelegate: AnyObject {
    func setStatus(_ status: String)
}

class EditStatusViewController: UIViewController {
    
    var status: String!
    let editStatusView = EditStatusView()
    var delegate: EditStatusControllerDelegate?
    
    init(status:String) {
        super.init(nibName: nil, bundle: nil)
        self.status = status
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(editStatusView)
        editStatusView.statusTextView.text = status
        editStatusView.statusTextView.delegate = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var textCount = 180
        if let count = editStatusView.statusTextView.text?.count {
            textCount -= count
        }
        navigationController?.navigationBar.topItem?.title = "Status(\(textCount))"
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        cancelButton.tintColor = .systemBlue
        let saveButton = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
        saveButton.tintColor = .systemBlue
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.topItem?.rightBarButtonItem = saveButton
    }
        
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        guard let status = editStatusView.statusTextView.text else { return }
        FirestoreService.manager.updateStatus(status) { (result) in
            switch result {
            case let .failure(error):
                print(error)
            case .success():
                self.delegate?.setStatus(status)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

extension EditStatusViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textCount = 180 - textView.text.count
        navigationController?.navigationBar.topItem?.title = "Status(\(textCount))"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return textView.text.count == 180 ? false : true
    }
}



