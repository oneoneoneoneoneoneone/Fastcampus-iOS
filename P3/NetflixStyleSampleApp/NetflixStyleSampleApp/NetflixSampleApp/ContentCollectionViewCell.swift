//
//  ContentCollectionViewCell.swift
//  NetflixStyleSampleApp
//
//  Created by hana on 2022/06/20.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell{
    let imageView = UIImageView()
    
    //디테일한 레이아웃 설정. storyboard에 control 추가 과정
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //contentView = Subview (self. 적용X)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        
        //auto layout
        imageView.snp.makeConstraints{
            //edges(top.bottom.leading.trailing)가 imageView의 Superview(contentView)와 일치하게
            $0.edges.equalToSuperview()
        }
    }
}
