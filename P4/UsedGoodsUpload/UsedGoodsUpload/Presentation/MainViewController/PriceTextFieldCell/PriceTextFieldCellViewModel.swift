//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by hana on 2022/09/27.
//

import RxSwift
import RxCocoa

struct PriceTextFieldCellViewModel{
    //뷰모델 -> 뷰
    let showFreeShareButton: Signal<Bool>               //무료나눔 버튼이 보이는지 여부
    let resetPrice: Signal<Void>
    
    //뷰 -> 뷰모델
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()    //무료나눔 버튼탭 이벤트를 저장
    
    init(){
        //True: 버튼 보임, False: 버튼 숨김
        self.showFreeShareButton = Observable
            .merge(
                //값이 0원일때
                priceValue.map{$0 ?? "" == "0"},
                //뮤료나눔 버튼을 누르면, 버튼을 숨김 = false처리
                freeShareButtonTapped.map{_ in false}
            )
            .asSignal(onErrorJustReturn: false)
        
        //무료나눔 버튼이 눌리면, 가격을 리셋함
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}
