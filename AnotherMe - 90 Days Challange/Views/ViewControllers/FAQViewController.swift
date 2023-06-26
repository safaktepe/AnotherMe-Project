//
//  FAQViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 10.12.2022.
//

import UIKit

class FAQViewController: UIViewController {

    @IBOutlet weak var faqTableView: UITableView!
    
    let goalsText = ["Read 20 pages of book" , "Visualize of future self", "Drink 1 gallon (3L) water", "30 min outside running", "Lift some weights for 30 minutes", "Follow a diet"]
    let goalsDecriptions = ["Immerse yourself in knowledge, expand your horizons, and stimulate your imagination.", "Envision your incredible potential and ignite motivation for self-improvement and growth.", "Hydrate, boost energy, improve focus, support digestion, and enhance overall well-being.", "Experience the exhilaration of a refreshing run, boost endurance, and improve mood.", "Strengthen your body, build muscle, improve physique, and enhance overall health.", "Nourish your body, manage weight, support health, and thrive with a balanced eating plan."]
    
    
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
        cell.faqTitle.text       = goalsText[indexPath.row]
        cell.faqDescription.text = goalsDecriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewHeight = tableView.bounds.size.height
        let cellHeight = viewHeight / 8.0
        return cellHeight

    }
    
    
}
