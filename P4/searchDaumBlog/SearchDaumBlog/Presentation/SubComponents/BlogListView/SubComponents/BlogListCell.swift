//
//  BlogListCell.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/07.
//

import UIKit
import SnapKit
import Kingfisher

class BlogListCell: UITableViewCell{
    let thumbnailImageView = UIImageView()
    let nameLable = UILabel()
    let titleLable = UILabel()
    let datetimeLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //외부로 전달할 이벤트X
        thumbnailImageView.contentMode = .scaleAspectFit
        
        nameLable.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLable.font = .systemFont(ofSize: 14)
        titleLable.numberOfLines = 2
        
        datetimeLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        [thumbnailImageView, nameLable, titleLable, datetimeLabel].forEach{
            contentView.addSubview($0)
        }
        
        nameLable.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(8)
            $0.trailing.lessThanOrEqualTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        thumbnailImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.top.trailing.bottom.equalToSuperview().inset(8)
            $0.width.height.equalTo(80)
        }
        
        titleLable.snp.makeConstraints{
            $0.top.equalTo(nameLable.snp.bottom).offset(8)
            $0.leading.equalTo(nameLable)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        datetimeLabel.snp.makeConstraints{
            $0.top.equalTo(titleLable.snp.bottom).offset(8)
            $0.leading.equalTo(nameLable)
            $0.trailing.equalTo(titleLable)
            $0.bottom.equalTo(thumbnailImageView)
        }
    }
    
    func setData(_ data: BlogListCellData){
        //받아온 데이터 설정
        thumbnailImageView.kf.setImage(with: data.thumbnailURL, placeholder: UIImage(systemName: "photo"))
        nameLable.text = data.name
        titleLable.text = data.title
        
        var datetime: String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let contentDate = data.datetime ?? Date()
            
            return dateFormatter.string(from: contentDate)
        }
        
        datetimeLabel.text = datetime
    }
}
