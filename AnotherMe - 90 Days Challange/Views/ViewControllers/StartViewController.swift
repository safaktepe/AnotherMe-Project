//
//  StartViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 27.01.2023.
//

import UIKit
import CoreData

class StartViewController: UIViewController {

    let context          = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 

    @IBAction func skipButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMainApp", sender: nil)
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
    
    @IBAction func startButtonClicked(_ sender: Any) {
        //Refactor below code.
        setGoals()
        
        // MARK: - Take current time
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
        
        performSegue(withIdentifier: "toMainApp", sender: nil)
        
    }
}
