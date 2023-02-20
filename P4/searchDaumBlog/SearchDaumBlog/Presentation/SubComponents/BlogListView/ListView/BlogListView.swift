//
//  BlogList.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BlogListView: UITableView{
    let disposeBag = DisposeBag()
    
    //FilterView - 커스텀한 UITableViewHeaderFooterView
    let headerView = FilterView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        )
    )
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: BlogListViewModel){
        headerView.bind(viewModel.filterViewModel)
        
        //delegate 함수인 cellForRowAt 대체
        viewModel.cellData
            .debug("BlogListView - cellData")
            .drive(self.rx.items){tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "BlogListCell", for: index) as! BlogListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        self.backgroundColor = .white
        self.register(BlogListCell.self, forCellReuseIdentifier: "BlogListCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
}
