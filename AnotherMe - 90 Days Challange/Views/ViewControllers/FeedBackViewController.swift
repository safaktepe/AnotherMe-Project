//
//  FeedBackViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.12.2022.
//

import UIKit

class FeedBackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav                  = self.navigationController?.navigationBar
        nav?.barStyle            = UIBarStyle.black
        nav?.tintColor           = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
      
    }
}
