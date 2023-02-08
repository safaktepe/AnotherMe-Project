//
//  GetStartedCollectionViewCell.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 8.02.2023.
//

import UIKit

class GetStartedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: GetStartedCollectionViewCell.self)
    @IBOutlet weak var cellAgeLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackgroundView.layer.cornerRadius = 10
    }

}
