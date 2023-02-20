//
//  FilterView.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterView: UITableViewHeaderFooterView{
    let disposeBag = DisposeBag()
    
    let sortButton = UIButton()
    let bottomBorder = UIView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: FilterViewModel){
        //sortButton이 탭되었을 때 이벤트를 sortButtonTap로 바인딩. 이벤트를 전달함
        sortButton.rx.tap
            .debug("FilterView - tap")
            .bind(to: viewModel.sortButtonTap)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        bottomBorder.backgroundColor = .lightGray
    }
    
    private func layout(){
        [sortButton, bottomBorder]
            .forEach{
                addSubview($0)
            }
        
        sortButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(28)
        }
        
        bottomBorder.snp.makeConstraints{
            $0.top.equalTo(sortButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
