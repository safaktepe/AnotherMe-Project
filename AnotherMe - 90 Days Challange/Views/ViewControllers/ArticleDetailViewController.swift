//
//  ArticleDetailViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 1.02.2023.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var gradientContainerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var titleLabel       : UILabel!
    
    
    var articleTitle : String?
    var articleDescr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setArticle()
        setGradientLayer()
}
        
    
    fileprivate func setArticle() {
        titleLabel.text       = articleTitle
        descriptionLabel.text = articleDescr
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    fileprivate func setGradientLayer() {
        // Transparent to black gradient for imageView's bottom.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.4]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientContainerView.layer.addSublayer(gradientLayer)
    }
    
}
