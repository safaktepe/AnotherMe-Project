//
//  PrefencesViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    let context             = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let name                = Notification.Name(rawValue: userInfoUpdateNotificationKey)
    var times      : [Time]?
    var users      : [User] = []
    
    @IBOutlet weak var profilePhoto       : UIImageView!
    @IBOutlet weak var settingsTableView  : UITableView!
    var profileViewController             : ProfileViewController?

    let settingsRowsNames = ["Account", "Restart Challange"]
    let segueNames        = ["toAccountPage", "toFeedBack"]
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        fetchImage()
        createNotificationObserver()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let profileViewController = segue.destination as? ProfileViewController{
              profileViewController.delegate = self
          }
      }

    fileprivate func setViews() {
        // To use on deleate-protocol.
        profileViewController = ProfileViewController()
        profileViewController?.delegate = self
        
        // Table View.
        settingsTableView.delegate   = self
        settingsTableView.dataSource = self
        settingsTableView.backgroundColor = .black
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        // Rounded imageView.
        profilePhoto.contentMode         = .scaleAspectFill
        profilePhoto.layer.cornerRadius  = profilePhoto.frame.height / 2
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor   = UIColor.white.cgColor
        profilePhoto.layer.borderWidth   = 3
        profilePhoto.clipsToBounds       = true
    }
    
    fileprivate  func calculateDif() -> Int {
        fetchTime()
        let savedDateCB : Date = (times?[0].startDate)!
        let newDate     = Date()
        let diffSeconds = Int(newDate.timeIntervalSince1970 - (savedDateCB.timeIntervalSince1970 ))
        let minutes     = diffSeconds / 60
        return minutes
    }
    
    fileprivate func fetchTime() {
        do {
            let request = Time.fetchRequest() as NSFetchRequest<Time>
            self.times = try context.fetch(request)
        } catch {
            print("time fetch error!")
        }
    }
    
    @objc fileprivate func fetchImage() {
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            self.users = try context.fetch(request)
        } catch {
            print("image fetch error!")
        }
        
        if let imageData = users.first?.image as? Data {
            profilePhoto.image = UIImage(data: imageData)
        }
    }
    
    fileprivate func restartChallange() {
        setGoals()
        let currentDate = Date()
        
        // MARK: -  If there are already data, delete them.
        let deleteFetch     = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
        let deleteRequest   = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }

        // MARK: - Save it.
        let saveMin       = Time(context: self.context)
        saveMin.startDate = currentDate
        saveMin.lastDate  = currentDate
        do {
            try self.context.save()
        } catch {
            print("error! time couldnt be saved!")
        }
        
        
 }
    fileprivate func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchImage), name: name, object: nil)
    }
        
    fileprivate func showAlert() {
        let alert = UIAlertController(title: "WARNING!", message: "If you restart challenge, your progress will be permanently deleted and it cannot be recovered!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { action in
            print("Restart")
            
            self.restartChallange()
            self.performSegue(withIdentifier: "toRestartChallange", sender: nil)
        }))
        present(alert, animated: true)
    }
    
    fileprivate func setGoals() {
        //MARK: - Delete
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }

        //MARK: - Objects
        let goalNumber1 = Goal(context: self.context)
        goalNumber1.title = "Read 20 pages of book"
        goalNumber1.id = 0
        goalNumber1.isCompleted = false
        
        let goalNumber2 = Goal(context: self.context)
        goalNumber2.title = "Visualize of future self"
        goalNumber2.id = 1
        goalNumber2.isCompleted = false

        
        let goalNumber3 = Goal(context: self.context)
        goalNumber3.title = "Drink 1 gallon (3L) water"
        goalNumber3.id = 2
        goalNumber3.isCompleted = false
        
        
        let goalNumber4 = Goal(context: self.context)
        goalNumber4.title = "30 min outside running"
        goalNumber4.id = 3
        goalNumber4.isCompleted = false
        
        let goalNumber5 = Goal(context: self.context)
        goalNumber5.title = "Lift some weights for 30 minutes"
        goalNumber5.id = 4
        goalNumber5.isCompleted = false
        
        let goalNumber6 = Goal(context: self.context)
        goalNumber6.title = "Follow a diet"
        goalNumber6.id = 5
        goalNumber6.isCompleted = false
        
        
        //MARK: - Save new objects.
        do {
            try self.context.save()
        }
        catch {
            print("error! data couldnt be saved!")
        }
    }
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsRowsNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        guard let cell = settingsTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SettingsTableViewCell else {
            fatalError("Unable to dequeue SettingsTableViewCell")
        }
        
        cell.settingsLabel.text = settingsRowsNames[indexPath.row]
        
        if indexPath.row == 3 {
            cell.settingsLabel.textColor = .red
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = settingsTableView.cellForRow(at: indexPath)
        settingsTableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
         performSegue(withIdentifier: "toAccountPage", sender: cell)
        }
        if indexPath.row == 1 {
            showAlert()
        }
    }
}

extension SettingsViewController: ProfileViewControllerDelegate {
    func didUserTappedUpdate(imageData: Data) {
        profilePhoto.image = UIImage(data: imageData)
    }
}
