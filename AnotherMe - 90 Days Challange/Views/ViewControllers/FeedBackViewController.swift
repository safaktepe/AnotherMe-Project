//
//  FeedBackViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.12.2022.
//

import UIKit
import Firebase

class FeedBackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        var user = Auth.auth().currentUser?.uid
        print(user)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange] // swift 4.2
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "removeThis", sender: nil)
        } catch {
            print("Error")
        }
    }
}
