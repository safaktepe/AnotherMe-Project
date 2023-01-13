//
//  AccountViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.12.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import CoreData

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    let myImageViewCornerRadius: CGFloat = 75.0
    
    let imageButton         = UIButton()
    let editButton          = UIButton()
    let firstNameLabel      = UILabel()
    let lastNameLabel       = UILabel()
    let firstNameTextField  = UITextField()
    let lastNameTextField   = UITextField()
    let deleteAccountButton = UIButton(type: .system)
    let saveButton          = UIButton(type: .system)
    var downloadImage       : String = ""
    var mainViewModel       : MainViewModel = MainViewModel()
    var photoData           : Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupProfilePhoto()
    }
    
    
    func setView() {
        
        //Profile image button.
        imageButton.layer.cornerRadius  = myImageViewCornerRadius
        imageButton.layer.masksToBounds = true
        imageButton.contentVerticalAlignment = .fill
        imageButton.contentHorizontalAlignment = .fill
        imageButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageButton.layer.borderColor   = UIColor.black.cgColor
        imageButton.layer.borderWidth   = 3
        imageButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        view.addSubview(imageButton)

        
        //ImageView's edit button.
        editButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        editButton.tintColor          = .red
        editButton.layer.cornerRadius = 35.0
        editButton.contentVerticalAlignment   = .fill
        editButton.contentHorizontalAlignment = .fill
        editButton.imageEdgeInsets            = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 5)
        view.addSubview(editButton)
        
        //Name Label
        firstNameLabel.textColor     = .black
        firstNameLabel.textAlignment = .center
        firstNameLabel.text          = "First Name"
        view.addSubview(firstNameLabel)
        
        //Last Name Label
        lastNameLabel.textColor     = .black
        lastNameLabel.textAlignment = .center
        lastNameLabel.text          = "Last Name"
        view.addSubview(lastNameLabel)

        //First name textfield.
        firstNameTextField.placeholder        = "First Name"
        firstNameTextField.borderStyle        = UITextField.BorderStyle.roundedRect
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.no
        firstNameTextField.keyboardType       = UIKeyboardType.default
        firstNameTextField.returnKeyType      = UIReturnKeyType.done
        firstNameTextField.clearButtonMode    = UITextField.ViewMode.whileEditing
        firstNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(firstNameTextField)

        //Last name textfield.
        lastNameTextField.placeholder        = "Last Name"
        lastNameTextField.borderStyle        = UITextField.BorderStyle.roundedRect
        lastNameTextField.autocorrectionType = UITextAutocorrectionType.no
        lastNameTextField.keyboardType       = UIKeyboardType.default
        lastNameTextField.returnKeyType      = UIReturnKeyType.done
        lastNameTextField.clearButtonMode    = UITextField.ViewMode.whileEditing
        lastNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(lastNameTextField)
        
        //Save button
        
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 19)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        view.addSubview(saveButton)

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
    
    //MARK: - Functions
    @objc func deleteAccountButtonClicked(sender: UIButton!) {
        let user   = Auth.auth().currentUser
        let userID = user?.uid
        guard let userID = userID else { return }
        print("user id: \(userID)")
        
        let databaseRef = Database.database().reference().child("users").child(userID)
        let storageRef  = Storage.storage().reference().child("profile_photos").child("\(userID).jpg")
        storageRef.delete { err in
            if err != nil {
                print(err?.localizedDescription)
            } else {
                print("photo deleted succesfully from storage!")
            }
        }
        databaseRef.removeValue()
        
        user?.delete(completion: { error in
            if error != nil {
                print("bu user silme hatası \(error?.localizedDescription)")
            } else {
                print("user deleted")
            }
        })
        self.performSegue(withIdentifier: "deleteThisTwo", sender: nil)

    }
    
    @objc func saveButtonClicked() {
        
        //BUG HERE !!! DONT LET USER CLICK BUTTON IF THERE IS NO IMAGE CHOOSEN BY USER!!!!!!

        guard let uid          = Auth.auth().currentUser?.uid            else { return }
        guard let image        = self.imageButton.imageView?.image       else { return }
        guard let uploadData   = image.jpegData(compressionQuality: 0.3) else { return }
        
        mainViewModel.setData(uploadData: uploadData)
        mainViewModel.uploadImage(userId: uid)
        
        //Save also in coredata
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context     = appDelegate.persistentContainer.viewContext
        
        let newImage    = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        newImage.setValue(uploadData, forKey: "image")
        
        do {
            try context.save()
            print("saved")
        } catch {
            print("error")
        }

}   
    
    @objc func editButtonClicked() {
        let imagePickerController           = UIImagePickerController()
        imagePickerController.delegate      = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage   = info[.editedImage]   as? UIImage {
            imageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }


    fileprivate func setupProfilePhoto() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let islandRef = Storage.storage().reference().child("profile_photos/\(uid).jpg")
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
              print(error.localizedDescription)
          } else {
              guard let data = data else { return }
              guard let imageOfButton = UIImage(data: data) else { return }
              self.imageButton.setImage(imageOfButton, for: .normal)
          }
    }
        
       
        
        
}
    
    func setConstraints() {
        imageButton          .translatesAutoresizingMaskIntoConstraints   = false
        editButton           .translatesAutoresizingMaskIntoConstraints   = false
        firstNameLabel       .translatesAutoresizingMaskIntoConstraints   = false
        lastNameLabel        .translatesAutoresizingMaskIntoConstraints   = false
        firstNameTextField   .translatesAutoresizingMaskIntoConstraints   = false
        lastNameTextField    .translatesAutoresizingMaskIntoConstraints   = false
        deleteAccountButton  .translatesAutoresizingMaskIntoConstraints   = false
        saveButton           .translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
                    imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    imageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    imageButton.widthAnchor.constraint(equalToConstant: 150.0),
                    imageButton.heightAnchor.constraint(equalToConstant: 150.0),
                    
                    
                    editButton.centerYAnchor.constraint(equalTo: imageButton.bottomAnchor,
                                                          constant: -myImageViewCornerRadius / 4.0),
                    editButton.centerXAnchor.constraint(equalTo: imageButton.trailingAnchor,
                                                         constant: -myImageViewCornerRadius / 4.0),
                    editButton.widthAnchor.constraint(equalToConstant: 50),
                    editButton.heightAnchor.constraint(equalToConstant: 40.0),
                    
                    
                    firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    firstNameLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 20),
                    
                    
                    firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
                    firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                    firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                    
                    
                    lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20.0),
                    lastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
                    
                    
                    lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 8),
                    lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                    lastNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
                    
                    saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    saveButton.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
                    saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                    saveButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                    
                    deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    deleteAccountButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 24),
                    deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                    deleteAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                    
     ])
                self.view = view
    }
      
}


