//
//  ViewModel.swift
//  RxSwift_Training
//
//  Created by hana on 2023/01/29.
//

import RxSwift
import RxCocoa

struct ViewModel{
    
    let resetText: Signal<Void>
    
    // Relay : 절대 끝나지 않음, 오직 .next이벤트만 가능 (PublishRelay, BehaviorRelay)
    let text = PublishRelay<String?>()
    let resetButtonTapped = PublishRelay<Void>()
    
    init(){        
        self.resetText = resetButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }
}
