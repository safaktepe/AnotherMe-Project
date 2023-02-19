//
//  HeaderView.swift
//  StretchyHeaderLBTA
//
//  Created by Brian Voong on 12/22/18.
//  Copyright © 2018 Brian Voong. All rights reserved.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {
    
    fileprivate let padding : CGFloat = 16
    
    //var cal : CGFloat?
    
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "article"))
        iv.contentMode = .redraw
        return iv
    }()
    
    let parentView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .white
        return myView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom code for layout
        addSubview(parentView)
        parentView.fillSuperview()
        setupGradientLayer()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var animator: UIViewPropertyAnimator!
    
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        let gradientContainerView = UIView()
        parentView.addSubview(gradientContainerView)
        
        gradientContainerView.addSubview(imageView)

        
        gradientContainerView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            imageView.heightAnchor.constraint(equalToConstant: gradientLayer.frame.height)
        ])
        
        
        gradientContainerView.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
        
        
        let heavyLabel = UILabel()
        heavyLabel.text = "Read more about being better 1% each day"
        heavyLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        heavyLabel.textColor = .white
        heavyLabel.numberOfLines = 2
        addSubview(heavyLabel)
        heavyLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: padding, bottom: padding, right: padding))
        
        
    }
    
   
    fileprivate func setupVisualEffectBlur() {
        parentView.addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        animator = UIViewPropertyAnimator(duration: 1.0, curve: .linear, animations: {
            self.visualEffectView.effect = nil
        })
        parentView.addSubview(visualEffectView)
        animator.isReversed = true
        animator.fractionComplete = 0
    }
}
