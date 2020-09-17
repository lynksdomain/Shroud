//
//  MessageViewController.swift
//  Shroud
//
//  Created by Lynk on 9/16/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    let messageView = MessageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(messageView)
        
    }
  
    override func viewDidLayoutSubviews() {
        messageView.setNeedsLayout()
        messageView.layoutIfNeeded()
        messageView.inputTextView.addBorder(toSide: .Top, withColor: UIColor.lightGray.withAlphaComponent(0.5).cgColor, andThickness: 0.3)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
