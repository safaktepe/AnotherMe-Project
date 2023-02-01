//
//  ArticleCollectionViewController.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 30.01.2023.
//

import UIKit

fileprivate let cellId    = "cellId"
fileprivate let headerId  = "headerId"
fileprivate let padding   : CGFloat = 16

class ArticleCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()
        setupCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        headerView?.visualEffectView.effect = UIBlurEffect(style: .regular)
        headerView?.layoutIfNeeded()
}
    
    
    // MARK: - Func.
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    fileprivate func setupCollectionViewLayout() {
        if let layout = collectionViewLayout as? StretchyHeaderLayout {
            layout.sectionInset  = .init(top: padding + 24, left: padding, bottom: padding, right: padding)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > 0 {
            return
        }
//        headerView?.animator.fractionComplete = abs(contentOffsetY) / 100
    }
    
    // MARK: - CollectinoView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    var headerView: HeaderCollectionView?

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionView
        return headerView!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height / 2.4 )
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        cell.titleLabel.text       = "Explore the importance of visulazation"
        cell.descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - (2 * padding), height: 200)
    }

}
