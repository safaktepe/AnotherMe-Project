//
//  FAQViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 10.12.2022.
//

import UIKit

class FAQViewController: UIViewController {

    @IBOutlet weak var faqTableView: UITableView!
    
    let goalsText          = ["goal1" , "goal2", "goal3", "goal4", "goal5", "goal6", "goal7"]
 
    
    let goalsDecriptions   = ["goal1Descr", "goal2Descr","goal3Descr", "goal4Descr", "goal5Descr", "goal6Descr", "goal7Descr",  ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faqTableView.dataSource = self
        faqTableView.delegate   = self
        faqTableView.backgroundColor = .white
        faqTableView.register(UINib(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}


extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalsText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        
        guard let cell = faqTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? FAQTableViewCell else {
            fatalError("Unable to dequeue FAQTableViewCell")
        }
        cell.faqTitle.text       = goalsText[indexPath.row].localize()
        cell.faqDescription.text = goalsDecriptions[indexPath.row].localize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewHeight = tableView.bounds.size.height
        let cellHeight = viewHeight / 8.0
        return cellHeight

    }
    
    
}
