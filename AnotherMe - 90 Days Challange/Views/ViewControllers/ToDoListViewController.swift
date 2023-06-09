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
    let checkMarkRed     = UIImage(systemName: "circle.fill")
    let checkMarkEmpty   = UIImage(systemName: "circle")

    let dailyGoals  = ["Do this", "Do that", "Go run", "Bla bla", "Drink Water" , "Visualize for 5 min"]
    let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var goals       : [Goal]?
    var times       : [Time]?
    var timeDifference : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        checkLastSavedDate()

    }
    
    override func viewDidLayoutSubviews() {
        didUserFinishedChallange()
    }
    
    fileprivate func didUserFinishedChallange() {
        timeDifference = calculateDif() + 1
        
        if timeDifference > 3 {
            performSegue(withIdentifier: "toChallangeDone", sender: nil)
        }
    }
    
    fileprivate func updateTimeLabel() {
        if calculateDif() > 75 {
            dayTitleLabel.text = "DAY 75"
        } else {
            dayTitleLabel.text = "DAY \(calculateDif() + 1)"
        }
    }
    
    fileprivate func setViews() {
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        if calculateDif() > 75 {
            dayTitleLabel.text = "DAY 75"
        } else {
            dayTitleLabel.text = "DAY \(calculateDif() + 1)"
        }
    }
    
    fileprivate  func calculateDif() -> Int {
        fetchTime()
        let startDate       : Date = (times?[0].startDate)!
        let currentDate     = Date()
        
        let daysBetween = Date.daysBetween(start: startDate, end: currentDate) // 365
        return daysBetween

    }
    
    
    fileprivate func checkLastSavedDate() {
        fetchTime()
        var lastSavedDate : Date = (times?[0].lastDate)!
        
        let calendar     = Calendar.current
        let currentDate   = Date()
        
        let isGivenDatesSameDay = calendar.isDate(lastSavedDate, equalTo: currentDate, toGranularity: .day)

        if isGivenDatesSameDay {
         // The two dates are in the same exact day.
            print("TODO calculate dif: \(calculateDif() + 1)")
        } else {
        //  The two dates are not in the  same day.
            for goal in goals ?? [] {
            goal.isCompleted = false
            }
            lastSavedDate = currentDate
            times?[0].lastDate = lastSavedDate
            try? context.save()
            self.tableView.reloadData()
            updateTimeLabel()
        }
    }
   
    
    fileprivate func strikeThrough(isStruck: Bool, title: String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        if isStruck {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        }
        return attributeString
    }
    
    
    fileprivate func fetchData() {
        do {
            let request = Goal.fetchRequest() as NSFetchRequest<Goal>
            let sort = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sort]
            self.goals =  try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("data couldnt fetched!!!")
        }
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
        return goals?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TodoTableViewCell
        
        let myGoal = self.goals![indexPath.row]
        cell.delegate = self
        cell.index = indexPath
        let titleLabel = myGoal.title
        
        if myGoal.isCompleted == false {
            cell.checkMarkButton.tintColor = .white
            cell.checkMarkButton.setImage(checkMarkEmpty, for: .normal)
            cell.titleLabel.textColor = .white
            cell.titleLabel.attributedText = strikeThrough(isStruck: false, title: titleLabel ?? "")
}
        
         if myGoal.isCompleted == true{
            cell.checkMarkButton.tintColor = .red
            cell.checkMarkButton.setImage(checkMarkRed, for: .normal)
            cell.titleLabel.textColor = .red
            cell.titleLabel.attributedText = strikeThrough(isStruck: true, title: titleLabel ?? "")
        }
        return cell
    }
}



extension ToDoListViewController:  MyCellDelegate {
    func onClickCell(index: Int) {
        print("\(index + 1 ) clicked")
        let hedef = self.goals![index]
        if hedef.isCompleted == true {
         hedef.isCompleted = false
        }else {
            hedef.isCompleted = true
        }
            do {
            try self.context.save()
        }
        catch {
            print("update error")
        }
        self.tableView.reloadData()
    }
}


extension Date {
    
    //Calculates to days between 2 given dates.
    
    func daysBetween(date: Date) -> Int {
        return Date.daysBetween(start: self, end: date)
    }
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
    }
}
