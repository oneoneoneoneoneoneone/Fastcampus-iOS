//
//  TitleTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by hana on 2022/09/27.
//

import RxCocoa

struct TitleTextFieldCellViewModel{
    //ui 이벤트를 받을 객체
    let titleText = PublishRelay<String?>()
}
