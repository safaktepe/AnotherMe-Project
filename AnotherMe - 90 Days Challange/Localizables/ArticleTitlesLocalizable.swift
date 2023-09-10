//
//  ArticleTitlesLocalizable.swift
//  AnotherMe - 90 Days Challange
//
//  Created by Mert Şafaktepe on 23.06.2023.
//

import Foundation


enum ArticleTitlesLocalizable: String {
    case articleTitle1 = "articleTitle1"
    case articleTitle2 = "articleTitle2"
    case articleTitle3 = "articleTitle3"
    case articleTitle4 = "articleTitle4"
    case articleTitle5 = "articleTitle5"
    case articleTitle6 = "articleTitle6"
    case articleTitle7 = "articleTitle7"
    
    func localized() -> String { rawValue.localized() }
}
