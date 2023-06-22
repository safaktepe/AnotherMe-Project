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
    
    var currentPage = 0 {
        didSet {
            if currentPage == slides.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
                // Go to next page.
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate    = self
        collectionView.dataSource  = self
        setSlideArray()

    }
    
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if currentPage == slides.count - 1 {
            // Go to next page.
            if let controller = storyboard?.instantiateViewController(withIdentifier: "toGetStarted") as? UIViewController {
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .flipHorizontal
                present(controller, animated: true)
            }
        } else {
            currentPage += 1
            pageController.currentPage = currentPage
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    fileprivate func setSlideArray() {
        slides = [OnboardingSlide(title: "Transform your life", description: "Push limits, redefine mindset, and become your best self in just 75 days.", image: UIImage(named: "run")!),
        
        OnboardingSlide(title: "Unleash Your Inner Potential", description: "Unlock talents, develop habits, and overcome obstacles to achieve greatness.", image: UIImage(named: "juststart")!),
                  
        OnboardingSlide(title: "Elevate Your Life to New Heights", description: "Experience a transformative journey, elevating fitness, well-being, growth, and success to new heights.", image: UIImage(named: "win")!)
        ]
    }
}

extension OnboardingCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifer, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageController.currentPage = currentPage
    }
    
}
