//
//  FeedBackViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.12.2022.
//

import UIKit

class FeedBackViewController: UIViewController {
    let myImageViewCornerRadius: CGFloat = 40.0


    override func viewDidLoad() {
        super.viewDidLoad()
            
        let myImageView = UIImageView()
        
        let myImageViewCornerRadius: CGFloat = 75.0
        
        // Just using a color for the example...
        myImageView.backgroundColor = .blue
        myImageView.layer.cornerRadius = myImageViewCornerRadius
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(myImageView)
        
        let myEditButton = UIButton()
        // Again using a color...
        myEditButton.backgroundColor = .red
        myEditButton.translatesAutoresizingMaskIntoConstraints = false
        myEditButton.layer.cornerRadius = 10.0
        view.addSubview(myEditButton)
        
        NSLayoutConstraint.activate([
                    myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    myImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    myImageView.widthAnchor.constraint(equalToConstant: 150.0),
                    myImageView.heightAnchor.constraint(equalToConstant: 150.0),
                    
                    myEditButton.centerYAnchor.constraint(equalTo: myImageView.bottomAnchor,
                                                          constant: -myImageViewCornerRadius / 4.0),
                    
                    myEditButton.centerXAnchor.constraint(equalTo: myImageView.trailingAnchor,
                                                         constant: -myImageViewCornerRadius / 4.0),
                    
                    myEditButton.widthAnchor.constraint(equalToConstant: 20.0),
                    myEditButton.heightAnchor.constraint(equalToConstant: 20.0)
                ])
         
                self.view = view
        
    }
}
