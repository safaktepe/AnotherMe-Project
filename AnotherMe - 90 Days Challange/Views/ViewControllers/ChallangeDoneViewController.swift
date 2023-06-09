//
//  ChallangeDoneViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 9.06.2023.
//

import UIKit
import Lottie

class ChallangeDoneViewController: UIViewController {
    
    var animationView           : LottieAnimationView!
    let titleLabel              = UILabel()
    let descriptionLabel        = UILabel()
    let backButton              = UIButton(type: .system)
    let restartButton           = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }
    
    
    fileprivate func setUI () {
        //Animation View
        animationView                = .init(name: "done")
        animationView.frame          =  view.frame
        animationView.contentMode    = .scaleToFill
        animationView.loopMode       = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
        
        //Title Label
        titleLabel.numberOfLines = 1
        titleLabel.text = "Congratulations!"
        titleLabel.textColor = .systemRed
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        //Description Label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "You succesfully finished the challange!"
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        descriptionLabel.adjustsFontSizeToFitWidth = true
        
        // Buttons
        backButton.layer.cornerRadius = 20
        backButton.setTitle("Close", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        restartButton.layer.cornerRadius = 20
        restartButton.setTitle("Restart Challange", for: .normal)
        restartButton.backgroundColor = .systemBlue
        restartButton.addTarget(self, action: #selector(restartButtonClicked), for: .touchUpInside)
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(restartButton)
        view.addSubview(descriptionLabel)
        
        animationView.translatesAutoresizingMaskIntoConstraints    = false
        titleLabel.translatesAutoresizingMaskIntoConstraints       = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints       = false
        restartButton.translatesAutoresizingMaskIntoConstraints    = false

        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            
            // Close button
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            backButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            backButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2),

            // Lottie
            animationView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            //Restart button
            restartButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 16),
            restartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            restartButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
            
        ])
    }
    
    @objc func backButtonClicked(_ sender: Any) {
        print("back button clicked")
    }
    
    @objc func restartButtonClicked(_ sender: Any) {
        print("restart button clicked")
    }
}
