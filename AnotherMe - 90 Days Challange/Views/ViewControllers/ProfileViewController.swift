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
   
    let myImageViewCornerRadius: CGFloat = 75.0
    let context  = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hasPickedNewImage   = false
    let imageButton         = UIButton()
    let editButton          = UIButton()
    let firstNameLabel      = UILabel()
    let firstNameTextField  = UITextField()
    let deleteAccountButton = UIButton(type: .system)
    let saveButton          = UIButton(type: .system)
    var downloadImage       : String = ""
    var photoData           : Data?
    weak var delegate       : ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        firstNameTextField.delegate = self
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
    
    
    @objc func saveButtonClicked() {
        let newName = firstNameTextField.text
        let newImage = imageButton.imageView?.image
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
                if let newName = name, !newName.isEmpty {
                    user.name = newName
                }
                if hasPickedNewImage, let newImage = image, let imageData = newImage.pngData() {
                    user.image = imageData
                    hasPickedNewImage = false
                    delegate?.didUserTappedUpdate(imageData: imageData)
                }
                try context.save()
            } else {
                let user = User(context: context)
                if let newName = name, !newName.isEmpty {
                    user.name = newName
                }
                if hasPickedNewImage, let newImage = image, let imageData = newImage.pngData() {
                    user.image = imageData
                    hasPickedNewImage = false
                }
                try context.save()
            }
        } catch {
            print("Error updating user settings: \(error)")
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
            hasPickedNewImage = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            hasPickedNewImage = true
        }
        dismiss(animated: true, completion: nil)
        saveButton.alpha = 1
        saveButton.isUserInteractionEnabled = true
    }

    //MARK: - UI
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
        
        //First name textfield.
        firstNameTextField.placeholder        = "First Name"
        firstNameTextField.borderStyle        = UITextField.BorderStyle.roundedRect
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.no
        firstNameTextField.keyboardType       = UIKeyboardType.default
        firstNameTextField.returnKeyType      = UIReturnKeyType.done
        firstNameTextField.clearButtonMode    = UITextField.ViewMode.whileEditing
        firstNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        view.addSubview(firstNameTextField)

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
        view.addSubview(deleteAccountButton)
        setConstraints()
    }
    
    func setConstraints() {
        imageButton          .translatesAutoresizingMaskIntoConstraints   = false
        editButton           .translatesAutoresizingMaskIntoConstraints   = false
        firstNameLabel       .translatesAutoresizingMaskIntoConstraints   = false
        firstNameTextField   .translatesAutoresizingMaskIntoConstraints   = false
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
                    firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    saveButton.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
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

// MARK: - Extensions.

extension ProfileViewController : UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            if !text.isEmpty{
                saveButton.isUserInteractionEnabled = true
                saveButton.alpha = 1
            } else {
                saveButton.isUserInteractionEnabled = true
                saveButton.alpha = 0.5
            }
            return true
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
