//
//  CategoryViewModel.swift
//  UsedGoodsUpload
//
//  Created by hana on 2022/09/27.
//

import RxSwift
import RxCocoa

struct CategoryViewModel{
    let disposeBag = DisposeBag()
    
    //뷰모델 -> 뷰
    let cellData: Driver<[Category]>                    //셀 데이터(카테고리 정보)
    let pop: Signal<Void>                               //팝이벤트를 저장
    
    //뷰 -> 뷰모델
    let itemSelected = PublishRelay<Int>()
    //뷰모델 -> Parents뷰모델
    let selectedCategory = PublishSubject<Category>()   //선택된 카테고리
    
    init(){
        let categories = [
            Category(id: 1, name: "디지털/가전"),
            Category(id: 2, name: "패션/잡화"),
            Category(id: 3, name: "가구"),
            Category(id: 4, name: "기타")
        ]
        
        self.cellData = Driver.just(categories)
        
        self.itemSelected
        //선택된 row값으로 카테고리 맵핑(변환)
            .map{categories[$0]}
        //전달할 형식 - selectedCategory
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        //카테고리가 선택됐을때
        self.pop = itemSelected
        //값과 상관 없이 void로 변환
            .map{_ in Void()}
        //signal로 변환
            .asSignal(onErrorSignalWith: .empty())
    }
}
