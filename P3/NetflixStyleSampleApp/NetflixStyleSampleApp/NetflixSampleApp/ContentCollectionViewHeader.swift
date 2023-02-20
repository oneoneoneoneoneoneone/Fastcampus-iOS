//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by hana on 2022/06/20.
//

import UIKit
import SnapKit

//header, footer - UICollectionReusableView
class ContentCollectionViewHeader: UICollectionReusableView{
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17 , weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit()
        
        //ReusableView
        addSubview(sectionNameLabel)
        
        //auto layout
        sectionNameLabel.snp.remakeConstraints{
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
}
