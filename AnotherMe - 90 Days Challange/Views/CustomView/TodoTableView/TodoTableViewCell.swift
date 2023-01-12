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
    
    let checkMarkEmpty = UIImage(systemName: "circle")
    let checkMarkRed   = UIImage(systemName: "circle.fill")

    var didChecked : Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func checkMarkButtonClicked(_ sender: Any) {
        
        if didChecked == false {
            didChecked = true
            checkMarkButton.tintColor = .red
            checkMarkButton.setImage(checkMarkRed, for: .normal)
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: titleLabel.text!)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
            titleLabel.attributedText = attributeString
        }
        
        else {
            didChecked = false
            checkMarkButton.tintColor = .white
            let attributeString = NSMutableAttributedString(string: titleLabel.text!)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughColor, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            checkMarkButton.setImage(checkMarkEmpty, for: .normal)
        }
        
        
       
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  
    
}
