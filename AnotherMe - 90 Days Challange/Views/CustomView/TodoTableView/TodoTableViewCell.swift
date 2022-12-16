//
//  TodoTableViewCell.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func checkMarkButtonClicked(_ sender: Any) {
        let checkMarkRed = UIImage(systemName: "circle.fill")
        checkMarkButton.tintColor = .red
        checkMarkButton.setImage(checkMarkRed, for: .normal)
        
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "Your Text")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        titleLabel.attributedText = attributeString
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  
    
}
