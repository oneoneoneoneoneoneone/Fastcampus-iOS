//
//  SearchBarViewModel.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/22.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel{
    //view로부터 전달받을
    let queryText = PublishRelay<String?>()
    //서브젝트와 동일, onNext만 받음(에러이벤트 받지 않음)
    let searchButtonTap = PublishRelay<Void>()
    //SearchBar 외부로 내보낼 이벤트. 검색어 최종 값
    let shouldLoadResult: Observable<String>
    
    init(){

        
        self.shouldLoadResult = searchButtonTap
        //옵셔널처리를 왜 $1 ???
            .withLatestFrom(queryText) {$1 ?? ""}
            .filter{!$0.isEmpty}
            .distinctUntilChanged()
    }
}
