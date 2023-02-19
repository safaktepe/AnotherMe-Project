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
    let name            = Notification.Name(rawValue: userInfoUpdateNotificationKey)
    var times           : [Time]?
    var isShared        : Bool = false
    var names           : [User]?
    var timeDifference  : Int = 0
    
    @IBOutlet weak var cons             : NSLayoutConstraint!
    @IBOutlet weak var shareButton      : UIButton!
    @IBOutlet weak var labelsStackView  : UIStackView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var faqButton        : UIButton!
    @IBOutlet weak var profilePhoto     : UIImageView!
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var nameLabel        : UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNotificationObserver()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeDifference = calculateDif()
        collectionView.reloadData()
    }
   
    @IBAction func faqButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "help", sender: nil)
    }
    
    func setShareButtonViewChanges () {
        profilePhoto.isHidden     = !profilePhoto.isHidden
        labelsStackView.isHidden  = !labelsStackView.isHidden
        faqButton.isHidden        = !faqButton.isHidden
        titleLabel.isHidden       = !titleLabel.isHidden
        let scaleImage  = profilePhoto.frame.size
        let imageHeight = scaleImage.height
        let holdCons : NSLayoutConstraint = cons
        cons.constant = (imageHeight + holdCons.constant) * (-1)
    }
    
   
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        if isShared == false {
            isShared = true
            setShareButtonViewChanges()
            guard let thisImage  = getScreenshot() else { return }
            UIImageWriteToSavedPhotosAlbum(thisImage, nil, nil, nil)
        } else {
            isShared = false
            setShareButtonViewChanges()
        }
    }
   
    
    fileprivate func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(userValuesCoreData), name: name, object: nil)
    }
    
    
    fileprivate func setUI() {
        timeDifference = calculateDif()
        userValuesCoreData()

        for i in 1...75 {
            totalSquaeres.append("\(i)")
        }
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        profilePhoto.layer.cornerRadius  = profilePhoto.frame.size.width / 2
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor   = UIColor.white.cgColor
        profilePhoto.layer.borderWidth   = 3
        profilePhoto.clipsToBounds = true
        profilePhoto.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped(tapGestureRecognizer:)))
        profilePhoto.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func profilePhotoTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.tabBarController?.selectedIndex = 3
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
        self.present(profileViewController, animated: true, completion: nil)
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
        
    fileprivate func getScreenshot() -> UIImage? {
        //creates new image context with same size as view
        // UIGraphicsBeginImageContextWithOptions (scale=0.0) for high res capture
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)

        // renders the view's layer into the current graphics context
        if let context = UIGraphicsGetCurrentContext() { view.layer.render(in: context) }

        // creates UIImage from what was drawn into graphics context
        let screenshot: UIImage? = UIGraphicsGetImageFromCurrentImageContext()

        // clean up newly created context and return screenshot
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    @objc func userValuesCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.persistentContainer.viewContext
          
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
          do {
              let results = try context.fetch(fetchRequest) as! [NSManagedObject]
              if let user = results.first as? User {
                  let name = user.name
                  if let imageData = user.image, let image = UIImage(data: imageData) {
                      nameLabel.text = name
                      profilePhoto.image = image
                  } else {
                      nameLabel.text = name
                      profilePhoto.image = nil
                  }
              }
          } catch {
              print("Error fetching user settings: \(error)")
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
        
        if indexPath.row <= timeDifference {
            cell.daysLabel.textColor = .red
        } else {
            cell.daysLabel.textColor = .white
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


