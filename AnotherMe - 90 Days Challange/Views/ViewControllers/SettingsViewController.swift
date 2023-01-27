//
//  PrefencesViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsRowsNames = ["Account", "Support & Feedback", "Photo library", "Notifications", "Logout"]
    //MARK:  - Buraya Hashmap ile image-label ikilisi olustur
    let segueNames = ["mert", "merttwo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setProfilePicture()
        
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
    
    fileprivate func setProfilePicture() {
      
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = settingsTableView.cellForRow(at: indexPath)
        settingsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: segueNames[indexPath.row], sender: cell)
        
    }
}
