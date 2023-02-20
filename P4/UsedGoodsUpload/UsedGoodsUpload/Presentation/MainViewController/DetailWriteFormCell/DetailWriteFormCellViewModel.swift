//
//  DetailWriteFormCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by hana on 2022/09/27.
//

import RxSwift
import RxCocoa

struct DetailWriteFormCellViewModel{
    //뷰 -> 뷰모델
    let contentValue = PublishRelay<String?>()
}
