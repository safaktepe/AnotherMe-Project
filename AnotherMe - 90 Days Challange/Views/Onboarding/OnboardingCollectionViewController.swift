//
//  OnboardingCollectionViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 2.02.2023.
//

import UIKit

class OnboardingCollectionViewController: UIViewController {

    @IBOutlet weak var nextButton       : UIButton!
    @IBOutlet weak var pageController   : UIPageControl!
    @IBOutlet weak var collectionView   : UICollectionView!
    
    var slides : [OnboardingSlide] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }
    
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
    }
    
}
