//
//  OnboardingCollectionViewCell.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 2.02.2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifer = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var imageView        : UIImageView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var titleLabel       : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    func setup(_ slide: OnboardingSlide) {
        titleLabel.text = slide.title
        descriptionLabel.text = slide.description
        imageView.image = slide.image
        
    }
    
    
    
}
