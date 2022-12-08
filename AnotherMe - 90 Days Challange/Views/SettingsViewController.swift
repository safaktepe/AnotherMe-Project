//
//  PrefencesViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let settingsRowsNames = ["Account", "Notifications", "Photo library", "Support & Feedback", "Delete Account"]
    //MARK:  - Buraya Hashmap ile image-label ikilisi olustur
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate   = self
        settingsTableView.backgroundColor = .black
        settingsTableView.dataSource = self
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
}
