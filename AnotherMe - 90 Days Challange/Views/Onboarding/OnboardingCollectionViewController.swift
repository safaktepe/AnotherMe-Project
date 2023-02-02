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
        } else {
            currentPage += 1
            pageController.currentPage = currentPage
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        
    }
    
    fileprivate func setSlideArray() {
        slides = [OnboardingSlide(title: "Eat Healthy", description: "Lorem Ipsum, kısaca Lipsum, masaüstü yayıncılık ve basın yayın sektöründe kullanılan taklit yazı bloğu olarak tanımlanır", image: UIImage(named: "article")!),
        
        OnboardingSlide(title: "Drink Water", description: "Lorem Ipsum, kısaca Lipsum, masaüstü yayıncılık ve basın yayın sektöründe kullanılan taklit yazı bloğu olarak tanımlanır", image: UIImage(named: "article")!),
                  
        OnboardingSlide(title: "Go Run", description: "Lorem Ipsum, kısaca Lipsum, masaüstü yayıncılık ve basın yayın sektöründe kullanılan taklit yazı bloğu olarak tanımlanır", image: UIImage(named: "article")!)
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
