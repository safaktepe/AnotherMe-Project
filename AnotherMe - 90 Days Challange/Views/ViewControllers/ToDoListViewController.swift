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
    var items       : [Goal]?
    var times       : [Time]?
    var timeDifference : Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
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
        let savedDateCB : Date = (times?[0].startDate)!
        let newDate     = Date()
        let diffSeconds = Int(newDate.timeIntervalSince1970 - (savedDateCB.timeIntervalSince1970 ))
        let minutes     = diffSeconds / 60
        return minutes
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
            self.items =  try context.fetch(request)
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
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TodoTableViewCell
        
        let myhedef = self.items![indexPath.row]
        cell.delegate = self
        cell.index = indexPath
        let titleLabel = myhedef.title
        
        if myhedef.isCompleted == false {
            cell.checkMarkButton.tintColor = .white
            cell.checkMarkButton.setImage(checkMarkEmpty, for: .normal)
            cell.titleLabel.textColor = .white
            cell.titleLabel.attributedText = strikeThrough(isStruck: false, title: titleLabel ?? "")
}
        
         if myhedef.isCompleted == true{
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
        let hedef = self.items![index]
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
