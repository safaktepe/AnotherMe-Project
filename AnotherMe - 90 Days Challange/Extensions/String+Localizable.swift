//
//  String+Localizable.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 23.06.2023.
//

import Foundation


extension String {
    func localized(_ feature: FeatureKind = .presentation) -> String {
        var fileName = String()
        switch feature {
        case .presentation:
            fileName = "ArticleTitlesLocalizable"
        case .accessibility:
            fileName = "ArticlesLocalizable"
        }
        
        return NSLocalizedString(self,tableName: fileName, bundle: Bundle.main, value: String(), comment: String() )
        
    }
}
