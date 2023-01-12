//
//  ToDoListViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit


class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dailyGoals = ["Do this", "Do that", "Go run", "Bla bla", "Drink Water" , "Visualize for 5 min"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}



extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyGoals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TodoTableViewCell
        
        cell.titleLabel.text = dailyGoals[indexPath.row]
        return cell
    }
}
