//
//  FAQViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 10.12.2022.
//

import UIKit

class FAQViewController: UIViewController {

    @IBOutlet weak var faqTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        faqTableView.dataSource = self
        faqTableView.delegate = self
                faqTableView.register(UINib(nibName: "FAQTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}


extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = faqTableView.dequeueReusableCell(withIdentifier: "cell") as! FAQTableViewCell
        return cell
    }
    
    
}
