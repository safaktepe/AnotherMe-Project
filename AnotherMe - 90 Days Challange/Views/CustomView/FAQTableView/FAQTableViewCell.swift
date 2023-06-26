//
//  FAQTableViewCell.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 11.12.2022.
//

import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var faqIcon: UIImageView!
    @IBOutlet weak var faqDescription: UILabel!
    @IBOutlet weak var faqTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
            
    }
    
}
