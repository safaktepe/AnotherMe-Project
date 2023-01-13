//
//  CalenderViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit
import FirebaseAuth
import CoreData

class CalenderViewController: UIViewController {
    var totalSquaeres   = [String]()
    let mainViewModel   = MainViewModel()

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setProfilePicture()
        setProfilePhotoFromCD()
        
        
        for i in 1...75 {
            totalSquaeres.append("\(i)")
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    @IBAction func faqButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "help", sender: nil)

    }
    
    fileprivate func setViews() {
        profilePhoto.layer.cornerRadius  = profilePhoto.frame.size.width / 2
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor   = UIColor.white.cgColor
        profilePhoto.layer.borderWidth   = 3
        profilePhoto.clipsToBounds = true
    }
    fileprivate func setProfilePicture() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
      /*  mainViewModel.getProfileImage(uid: uid) { imageData, err in
            if err != nil {
                print("err")
                return
            }
        guard let imageData = imageData else { return }
        let image  = UIImage(data: imageData)
        self.profilePhoto.image = image
        }*/
    }
    
    fileprivate func setProfilePhotoFromCD() {
        
        
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let context      = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
           let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let imageData = result.value(forKey: "image") as? Data {
                    let image = UIImage(data: imageData)
                    profilePhoto.image = image
                }
            }
        } catch {
            print("error")
        }
        
        
    }
    
}


extension CalenderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquaeres.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCollectionViewCell
        cell.daysLabel.text = totalSquaeres[indexPath.row]
        return cell
    }
}

extension CalenderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSize                      = collectionView.frame.size
        let screenWidth                    = totalSize.width
        let screenHeight                   = totalSize.height
        
        return CGSize(width: (screenWidth - (11 * 2.0)) / 10, height: (screenHeight - (12 * 1.0)) / 11)
    }
}
