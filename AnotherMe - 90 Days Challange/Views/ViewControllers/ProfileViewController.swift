//
//  AccountViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.12.2022.
//

import UIKit
import CoreData

let userInfoUpdateNotificationKey = "userDataUpdated"

protocol ProfileViewControllerDelegate: AnyObject {
    func didUserTappedUpdate(imageData: Data)
}


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
   
    let myImageViewCornerRadius : CGFloat = 75.0
    weak var delegate           : ProfileViewControllerDelegate?
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var hasUserPickedNewImage = false
    let pickImageButton       = UIButton()
    let editButton            = UIButton()
    let nameLabel             = UILabel()
    let nameTextField         = UITextField()
    let deleteAccountButton   = UIButton(type: .system)
    let saveButton            = UIButton(type: .system)
    var downloadImage         : String = ""
    var photoData             : Data?
    var newName               : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        nameTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
 
    
    //MARK: - Functions
    fileprivate func deleteAllImagesCoreData() {
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Anotherme")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Failed to load Core Data stack: \(error)")
                }
            }
            return container
        }()

        
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "User")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["image"]
        
       
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest) as! [[String:Any]]
            for result in results {
                if let image = result["image"] as? Data {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    fetchRequest.predicate = NSPredicate(format: "image == %@", image as CVarArg)
                    do {
                        let users = try persistentContainer.viewContext.fetch(fetchRequest) as! [User]
                        for user in users {
                            user.image = nil
                        }
                        try persistentContainer.viewContext.save()
                    } catch {
                        print("Error deleting image data: \(error)")
                    }
                }
            }
        } catch {
            print("Error fetching image data: \(error)")
        }
    }
    
    @objc func deleteAccountButtonClicked(sender: UIButton!) {
        deleteAllImagesCoreData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           if let text = textField.text, !text.isEmpty {
               saveButton.isUserInteractionEnabled = true
               saveButton.alpha = 1
           } else {
               saveButton.isUserInteractionEnabled = false
               saveButton.alpha = 0.5
           }
       }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   
  
    @objc func saveButtonClicked() {
        let inputName = nameTextField.text
        
        if let inputName = inputName {
            newName = "\(inputName)"
        }
        let newImage = pickImageButton.imageView?.image
        updateUserSettings(name: newName, image: newImage)
        let updatedUser  = Notification.Name(rawValue: userInfoUpdateNotificationKey)
        NotificationCenter.default.post(name: updatedUser, object: nil)
        showAlert()
    }
    
    
    fileprivate func updateUserSettings(name: String?, image: UIImage?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            if let user = results.first as? User {
                if let newName = name, !newName.isEmpty, newName != "" {
                    user.name = newName
                }
                if hasUserPickedNewImage, let newImage = image, let imageData = newImage.pngData() {
                    user.image = imageData
                    hasUserPickedNewImage = false
                    delegate?.didUserTappedUpdate(imageData: imageData)
                }
                try context.save()
            } else {
                let user = User(context: context)
                if let newName = name, !newName.isEmpty {
                    user.name = newName
                }
                if hasUserPickedNewImage, let newImage = image, let imageData = newImage.pngData() {
                    user.image = imageData
                    hasUserPickedNewImage = false
                }
                try context.save()
            }
        } catch {
            print("Error updating user settings: \(error)")
        }
    }
    
    @objc func editButtonClicked() {
        let imagePickerController           = UIImagePickerController()
        imagePickerController.sourceType    = .photoLibrary
        imagePickerController.delegate      = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage   = info[.editedImage]   as? UIImage {
            pickImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            hasUserPickedNewImage = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            pickImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            hasUserPickedNewImage = true
        }
        dismiss(animated: true, completion: nil)
        saveButton.alpha = 1
        saveButton.isUserInteractionEnabled = true
    }

    //MARK: - UI
    func setView() {
        // Navbar.
        let nav                  = self.navigationController?.navigationBar
        nav?.barStyle            = UIBarStyle.default
        nav?.tintColor           = UIColor.black
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        title = "Edit Profile"
        
        //Profile image button.
        pickImageButton.layer.cornerRadius  = myImageViewCornerRadius
        pickImageButton.layer.masksToBounds = true
        pickImageButton.contentVerticalAlignment   = .fill
        pickImageButton.contentHorizontalAlignment = .fill
        pickImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
        pickImageButton.layer.borderColor   = UIColor.black.cgColor
        pickImageButton.layer.borderWidth   = 3
        pickImageButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        view.addSubview(pickImageButton)
        
        //ImageView's edit button.
        editButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        editButton.tintColor          = .red
        editButton.layer.cornerRadius = 35.0
        editButton.contentVerticalAlignment   = .fill
        editButton.contentHorizontalAlignment = .fill
        editButton.imageEdgeInsets            = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 5)
        view.addSubview(editButton)
        
        //Name Label
        nameLabel.textColor     = .black
        nameLabel.textAlignment = .center
        nameLabel.text          = "Name"
        view.addSubview(nameLabel)
        
        //First name textfield.
        nameTextField.placeholder        = "Enter Your Name"
        nameTextField.borderStyle        = UITextField.BorderStyle.roundedRect
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType       = UIKeyboardType.default
        nameTextField.returnKeyType      = UIReturnKeyType.done
        nameTextField.clearButtonMode    = UITextField.ViewMode.whileEditing
        nameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        view.addSubview(nameTextField)

        //Save button
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 19)
        saveButton.alpha = 0.5
        saveButton.isUserInteractionEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        view.addSubview(saveButton)

        //Delete account button.
        deleteAccountButton.backgroundColor = .red
        deleteAccountButton.setTitle("Delete Account", for: .normal)
        deleteAccountButton.layer.cornerRadius = 10
        deleteAccountButton.setTitleColor(.white, for: .normal)
        deleteAccountButton.titleLabel?.font = .systemFont(ofSize: 19)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonClicked), for: .touchUpInside)
//        view.addSubview(deleteAccountButton)
        setConstraints()
    }
    
    func setConstraints() {
        pickImageButton      .translatesAutoresizingMaskIntoConstraints   = false
        editButton           .translatesAutoresizingMaskIntoConstraints   = false
        nameLabel            .translatesAutoresizingMaskIntoConstraints   = false
        nameTextField        .translatesAutoresizingMaskIntoConstraints   = false
//        deleteAccountButton  .translatesAutoresizingMaskIntoConstraints   = false
        saveButton           .translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
                    pickImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    pickImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                    pickImageButton.widthAnchor.constraint(equalToConstant: 150.0),
                    pickImageButton.heightAnchor.constraint(equalToConstant: 150.0),
                    
                    editButton.centerYAnchor.constraint(equalTo: pickImageButton.bottomAnchor,
                                                          constant: -myImageViewCornerRadius / 4.0),
                    editButton.centerXAnchor.constraint(equalTo: pickImageButton.trailingAnchor,
                                                         constant: -myImageViewCornerRadius / 4.0),
                    editButton.widthAnchor.constraint(equalToConstant: 50),
                    editButton.heightAnchor.constraint(equalToConstant: 40.0),
                    
                    nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    nameLabel.topAnchor.constraint(equalTo: pickImageButton.bottomAnchor, constant: 20),
                                        
                    nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                    nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
                    saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                    saveButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
                    
//                    deleteAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                    deleteAccountButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 24),
//                    deleteAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
//                    deleteAccountButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
     ])
                self.view = view
    }
}

// MARK: - Extensions.

extension ProfileViewController : UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
}
  

extension ProfileViewController {

     func showAlert() {
         let alert = UIAlertController(title: "Saved!", message: "All changes are saved.", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("OK")
             self.saveButton.isUserInteractionEnabled = false
             self.saveButton.alpha = 0.5
        }))
        present(alert, animated: true)
    }
    
}
