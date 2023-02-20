//
//  Content.swift
//  NetflixStyleSampleApp
//
//  Created by hana on 2022/06/20.
//

import UIKit

//인코딩X쓰기작업X

struct Content: Decodable{
    let sectionType: SectionType
    let sectionName: String
    let contentItem: [Item]
    
    enum SectionType: String, Decodable{
        case basic
        case main
        case large
        case rank
        
        var identifier: String {
            switch self {
            case .basic:
                return "ContentCollecionViewCell"
            case .main:
                return "ContentCollectionViewMainCell"
            case .large:
                return "ContentCollecionViewLargeCell"
            case .rank:
                return "ContentCollecionViewRankCell"
            }
        }
    }
}

struct Item: Decodable{
    let description: String
    let imageName: String
    
    var image: UIImage{
        return UIImage(named: imageName) ?? UIImage()
    }
}
