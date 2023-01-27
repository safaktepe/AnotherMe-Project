//
//  ToDoListViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dailyGoals  = ["Do this", "Do that", "Go run", "Bla bla", "Drink Water" , "Visualize for 5 min"]
    let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var times : [Time]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        dayTitleLabel.text = "DAY \(calculateDif() + 1)"

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
