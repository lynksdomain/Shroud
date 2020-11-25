//
//  ImagePreviewViewController.swift
//  Shroud
//
//  Created by Lynk on 11/24/20.
//  Copyright © 2020 Lynk. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {
    let scroll = UIScrollView()
    let pictureView = UIImageView()
    var image: UIImage!
    
    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    @objc private func dismissPreview() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPreview))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = button
    }
    
    private func setUp() {
        view.backgroundColor = .black
        view.addSubview(scroll)
        scroll.delegate = self
        scroll.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.safeAreaLayoutGuide.layoutFrame.height)
        
        scroll.alwaysBounceVertical = false
        scroll.alwaysBounceHorizontal = false
        scroll.showsVerticalScrollIndicator = true
        scroll.flashScrollIndicators()
        
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 10.0
        scroll.addSubview(pictureView)
        pictureView.frame = CGRect(x: view.safeAreaLayoutGuide.layoutFrame.minX, y: view.safeAreaLayoutGuide.layoutFrame.minY, width: view.frame.width, height: view.frame.width)
    
        
        //        pictureView.translatesAutoresizingMaskIntoConstraints = false
//        pictureView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 11).isActive = true
//        pictureView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -11).isActive = true
//        pictureView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 11).isActive = true
//        pictureView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -11).isActive = true
        pictureView.contentMode = .scaleAspectFit
        scroll.contentMode = .top
        pictureView.image = image
    }
    

}

extension ImagePreviewViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pictureView
    }
}
