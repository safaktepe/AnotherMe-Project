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
    
    @IBAction func startButtonClicked(_ sender: Any) {
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
