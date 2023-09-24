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

//fileprivate let titles  : [ArticleTitlesLocalizable] = ["articleTitle1".localize(), .articleTitle2, .articleTitle3, .articleTitle4, .articleTitle5, .articleTitle6, .articleTitle7]


fileprivate let titles  = ["articleTitle1".localize(), "articleTitle2".localize(), "articleTitle3".localize(), "articleTitle4".localize(), "articleTitle5".localize(), "articleTitle6".localize(), "articleTitle7".localize()]

//fileprivate let articles    = [.article1, .article2, .article3, .article4, .article5, .article6, .article7]


fileprivate let articles    = ["article1".localize(), "article2".localize(), "article3".localize(), "article4".localize(), "article5".localize(), "article6".localize(), "article7".localize()]



class ArticleCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        headerView?.visualEffectView.effect = UIBlurEffect(style: .regular)
        headerView?.layoutIfNeeded()
}
    
    // MARK: - Func.
    fileprivate func setupCollectionView() {
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ArticleCollectionViewCell")
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        // Calculating tabbar height cuz it was covering some part of last cell.
        if let tabBarController = self.tabBarController {
            let tabBar = tabBarController.tabBar
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBar.frame.height, right: 0)
        }
        setupCollectionViewLayout()
        
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
    }
    
    // MARK: - CollectinoView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
//        return 8
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
        cell.titleLabel.text       =  titles[indexPath.row].localize()
        cell.descriptionLabel.text = articles[indexPath.row].localize()
        cell.layoutIfNeeded()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ArticleDetailViewController.instantiate()
        controller.articleTitle = titles[indexPath.row].localize()
        controller.articleDescr = articles[indexPath.row].localize()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - (2 * padding), height: 200)
    }

}
