//
//  TodoTableViewCell.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 7.12.2022.
//

import UIKit

protocol MyCellDelegate: AnyObject {
    func onClickCell(index: Int)
}

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkMarkButton: UIButton!
    private var someId : Int = 0
    weak var delegate  : MyCellDelegate?
    let checkMarkEmpty = UIImage(systemName: "circle")
    let checkMarkRed   = UIImage(systemName: "circle.fill")
    var index          : IndexPath?
    var didChecked     : Bool?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configure(with isDone: Bool, id: Int) {
        self.someId = id
            if isDone == false {
            checkMarkButton.tintColor = .blue
            checkMarkButton.setImage(checkMarkEmpty, for: .normal)
        }
        else {
            checkMarkButton.tintColor = .red
            checkMarkButton.setImage(checkMarkRed, for: .normal)
        }
    }
    
    
    @IBAction func checkMarkButtonClicked(_ sender: Any) {
        delegate?.onClickCell(index: index!.row)
    }
    
   
    
  
    
}



/*
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
 */
