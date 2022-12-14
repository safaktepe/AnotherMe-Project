//
//  AccountViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.12.2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    let myImageViewCornerRadius: CGFloat = 75.0
    
    let myImageView         = UIImageView()
    let myEditButton        = UIButton()
    let firstNameLabel      = UILabel()
    let lastNameLabel       = UILabel()
    let firstNameTextField  = UITextField()
    let lastNameTextField   = UITextField()
    let deleteAccountButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    
    func setView() {
        
        
        //ImageView
        myImageView.backgroundColor = .blue
        myImageView.layer.cornerRadius = myImageViewCornerRadius
        view.addSubview(myImageView)
        
        //ImageView's edit button.
        myEditButton.backgroundColor = .red
        myEditButton.layer.cornerRadius = 20.0
        view.addSubview(myEditButton)
        
        //Name Label
        firstNameLabel.textColor = .black
        firstNameLabel.textAlignment = .center
        firstNameLabel.text = "First Name"
        view.addSubview(firstNameLabel)
        
        //Last Name Label
        lastNameLabel.textColor = .black
        lastNameLabel.textAlignment = .center
        lastNameLabel.text = "Last Name"
        view.addSubview(lastNameLabel)

        //First name textfield.
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.no
        firstNameTextField.keyboardType = UIKeyboardType.default
        firstNameTextField.returnKeyType = UIReturnKeyType.done
        firstNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        firstNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(firstNameTextField)

        //Last name textfield.
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        lastNameTextField.autocorrectionType = UITextAutocorrectionType.no
        lastNameTextField.keyboardType = UIKeyboardType.default
        lastNameTextField.returnKeyType = UIReturnKeyType.done
        lastNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        lastNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(lastNameTextField)

        //Delete account button.
        deleteAccountButton.backgroundColor = .red
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.layer.cornerRadius = 10
        deleteAccountButton.setTitleColor(.white, for: .normal)
        deleteAccountButton.titleLabel?.font = .systemFont(ofSize: 19)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonClicked), for: .touchUpInside)
        view.addSubview(deleteAccountButton)

        setConstraints()
    }
    
    @objc func deleteAccountButtonClicked(sender: UIButton!) {
     print("account deleted")
 }
    
    func setConstraints() {
        myImageView.translatesAutoresizingMaskIntoConstraints            = false
        myEditButton.translatesAutoresizingMaskIntoConstraints           = false
        firstNameLabel.translatesAutoresizingMaskIntoConstraints         = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints          = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints     = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints      = false
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints    = false
        
        
        NSLayoutConstraint.activate([
                    myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    myImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    myImageView.widthAnchor.constraint(equalToConstant: 150.0),
                    myImageView.heightAnchor.constraint(equalToConstant: 150.0),
                    
                    myEditButton.centerYAnchor.constraint(equalTo: myImageView.bottomAnchor,
                                                          constant: -myImageViewCornerRadius / 4.0),
                    
                    myEditButton.centerXAnchor.constraint(equalTo: myImageView.trailingAnchor,
                                                         constant: -myImageViewCornerRadius / 4.0),
                    
                    myEditButton.widthAnchor.constraint(equalToConstant: 40.0),
                    myEditButton.heightAnchor.constraint(equalToConstant: 40.0),
                    
                    firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    firstNameLabel.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 20),
                    
                    firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 24),
                    firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                    
                    lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20.0),
                    lastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
                    
                    lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 24),
                    lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    lastNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                    
                    deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    deleteAccountButton.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 32),
                    deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                    deleteAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
     ])
                self.view = view
    }
      
}


