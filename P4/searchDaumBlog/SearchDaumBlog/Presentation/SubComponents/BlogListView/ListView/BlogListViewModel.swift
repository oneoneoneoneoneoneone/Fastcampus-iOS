//
//  BlogListViewModel.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/22.
//

import RxSwift
import RxCocoa

struct BlogListViewModel{
    //블로그리스트가 헤더뷰로 필터뷰를 사용하고있음
    let filterViewModel = FilterViewModel()
    //네트워크작업을 통해 전달된 값 MainViewController -> BlogListView
    let BlogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init(){
        self.cellData = BlogCellData
            .asDriver(onErrorJustReturn: [])
            .debug("BlogListViewModel - init")
    }
}
