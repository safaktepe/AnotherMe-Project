//
//  CalenderViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit
import CoreData

class CalenderViewController: UIViewController {
    var totalSquaeres   = [String]()
    let context         = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var times           : [Time]?

    @IBOutlet weak var collectionTopCons: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setProfilePhotoFromCD()
        print("calender view: dif is : \(calculateDif())")
        
        for i in 1...75 {
            totalSquaeres.append("\(i)")
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    @IBAction func faqButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "help", sender: nil)

    }
    
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        profilePhoto.isHidden = true
        faqButton.isHidden    = true
        welcomeLabel.isHidden = true
        nameLabel.isHidden    = true
    }
    
    fileprivate func setViews() {
        profilePhoto.layer.cornerRadius  = profilePhoto.frame.size.width / 2
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor   = UIColor.white.cgColor
        profilePhoto.layer.borderWidth   = 3
        profilePhoto.clipsToBounds = true
    }
   
    fileprivate func fetchTime() {
        do {
            let request = Time.fetchRequest() as NSFetchRequest<Time>
            self.times = try context.fetch(request)
        } catch {
            print("time fetch error!")
        }
    }
    
    fileprivate  func calculateDif() -> Int {
        fetchTime()
        let savedDateCB : Date = (times?[0].startDate)!
        let newDate     = Date()
        let diffSeconds = Int(newDate.timeIntervalSince1970 - (savedDateCB.timeIntervalSince1970 ))
        let minutes     = diffSeconds / 60
        return minutes
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
        
        if indexPath.row <= calculateDif() {
            cell.daysLabel.textColor = .red
        }
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
