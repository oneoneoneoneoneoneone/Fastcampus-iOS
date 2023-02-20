//
//  StationDetailCollectionViewCell.swift
//  SubwayStation
//
//  Created by hana on 2022/07/13.
//

import SnapKit
import UIKit

final class StationDetailCollectionViewCell: UICollectionViewCell{
    private lazy var linelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        
        return label
    }()
    private lazy var remainTimelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        
        return label
    }()
    
    func setup(with realTimeArrival: StationArrivalResponseModel.RealTimeArrival){
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        
        backgroundColor = .systemBackground
        
        [linelabel, remainTimelabel].forEach{
            addSubview($0)
        }
        
        linelabel.snp.makeConstraints{
            $0.leading.top.equalToSuperview().inset(16)
        }
        remainTimelabel.snp.makeConstraints{
            $0.leading.equalTo(linelabel)
            $0.top.equalTo(linelabel.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        linelabel.text = realTimeArrival.line
        remainTimelabel.text = realTimeArrival.remainTime
    }
}
