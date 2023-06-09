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
    let backButton              = UIButton()
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
        titleLabel.numberOfLines = 2
        titleLabel.text = "Congratulations! \n You succesfully finished the challange!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        // Buttons
        backButton.layer.cornerRadius = 20
        backButton.setTitle("Close", for: .normal)
        backButton.backgroundColor = .blue
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        restartButton.layer.cornerRadius = 20
        restartButton.setTitle("Restart Challange", for: .normal)
        restartButton.backgroundColor = .red
        restartButton.addTarget(self, action: #selector(restartButtonClicked), for: .touchUpInside)
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(restartButton)
        
        animationView.translatesAutoresizingMaskIntoConstraints    = false
        titleLabel.translatesAutoresizingMaskIntoConstraints       = false
        backButton.translatesAutoresizingMaskIntoConstraints       = false
        restartButton.translatesAutoresizingMaskIntoConstraints       = false

        NSLayoutConstraint.activate([
            // Lottie
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            // Buttons
            backButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            backButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            restartButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
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
