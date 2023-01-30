//
//  StretchyHeaderLayout.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 30.01.2023.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                let width = collectionView.frame.width
                
                attributes.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            }
            
        })
        
        
        return layoutAttributes
    }
    
}
