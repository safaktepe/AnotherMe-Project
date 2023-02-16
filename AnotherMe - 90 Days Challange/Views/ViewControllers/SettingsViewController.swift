//
//  PrefencesViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    let context    = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var times : [Time]?
    var users : [User] = []
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsRowsNames = ["Account", "Support & Feedback", "Restart Challange"]
    //MARK:  - Buraya Hashmap ile image-label ikilisi olustur
    let segueNames = ["mert", "merttwo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        fetchImage()
        settingsTableView.delegate   = self
        settingsTableView.dataSource = self
        settingsTableView.backgroundColor = .black
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    
    
    fileprivate func setViews() {
        profilePhoto.contentMode = .scaleAspectFill
        profilePhoto.layer.cornerRadius  = profilePhoto.frame.height / 2
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor   = UIColor.white.cgColor
        profilePhoto.layer.borderWidth   = 3
        profilePhoto.clipsToBounds = true
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
    
    fileprivate func fetchImage() {
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            self.users = try context.fetch(request)
        } catch {
            print("image fetch error!")
        }
        
        if let imageData = users.last?.image as? Data {
            profilePhoto.image = UIImage(data: imageData)
        }
        // REFACTOR HERE: PLACEHOLDER IMAGE
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
        do {
            try self.context.save()
        } catch {
            print("error! time couldnt be saved!")
        }
        
        
 }
    
        
    fileprivate func showAlert() {
        let alert = UIAlertController(title: "WARNING!", message: "If you restart challenge, your progress will be permanently deleted and it cannot be recovered!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dissmiss", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Restart", style: .destructive, handler: { action in
            print("Restart")
            
            self.restartChallange()
            self.tabBarController?.selectedIndex = 0


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
        let newHedef = Goal(context: self.context)
        newHedef.title = "Goal number one"
        newHedef.id = 0
        newHedef.isCompleted = false
        
        let secHedef = Goal(context: self.context)
        secHedef.title = "Goal number two"
        secHedef.id = 1
        secHedef.isCompleted = false

        
        let thirdHedef = Goal(context: self.context)
        thirdHedef.title = "Goal number three"
        thirdHedef.id = 2
        thirdHedef.isCompleted = false
        
        
        let fourthHedef = Goal(context: self.context)
        fourthHedef.title = "Goal number four"
        fourthHedef.id = 3
        fourthHedef.isCompleted = false
        
        let fifthHedef = Goal(context: self.context)
        fifthHedef.title = "Goal number five"
        fifthHedef.id = 4
        fifthHedef.isCompleted = false
        
        let sixthHedef = Goal(context: self.context)
        sixthHedef.title = "Goal number six"
        sixthHedef.id = 5
        sixthHedef.isCompleted = false
        
        let seventhHedef = Goal(context: self.context)
        seventhHedef.title = "Goal number seven"
        seventhHedef.id = 6
        seventhHedef.isCompleted = false
        
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
        
        //MARK: REFACTOR HERE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        // !!!!!!!!!!!!!!!!!!
        // !!!!!!!!!!!!!!!!!!
        // !!!!!!!!!!!!!!!!!!

        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "cell") as! SettingsTableViewCell
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
        if indexPath.row < 2 {
         performSegue(withIdentifier: segueNames[indexPath.row], sender: cell)
        }
        if indexPath.row == 2 {
            showAlert()
        }
        
        
    }
}
