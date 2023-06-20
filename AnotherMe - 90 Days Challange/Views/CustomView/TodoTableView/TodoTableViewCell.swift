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



