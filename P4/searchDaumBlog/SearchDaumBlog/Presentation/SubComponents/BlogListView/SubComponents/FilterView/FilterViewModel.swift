//
//  FilterViewModel.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/22.
//

import RxSwift
import RxCocoa

struct FilterViewModel{
    ///FilterView 외부에서 관찰할 sortButton이 탭되었을 때 이벤트
    let sortButtonTap = PublishRelay<Void>()
    
}
