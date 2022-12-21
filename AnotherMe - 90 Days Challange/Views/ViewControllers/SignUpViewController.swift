//
//  SignUpViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 15.12.2022.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordText  : UITextField!
    @IBOutlet weak var emailText     : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()



    }
        
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        guard let email    = emailText.text,    !email.isEmpty    else { return }
        guard let password = passwordText.text, !password.isEmpty else { return }
        
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: email, password: password) { (authdata , error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toApp", sender: nil)
                }
            }
        } else {
            makeAlert(titleInput: "Error", messageInput: "Username or Password is empty!")
        }
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        guard let email    = emailText.text,     !email.isEmpty      else { return }
        guard let password = passwordText.text,  !password.isEmpty   else { return }

        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: email, password: password) { (authdata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")

                } else {
                    self.performSegue(withIdentifier: "toApp", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Username or Password is empty!")
            }
        
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert   = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button  = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}
