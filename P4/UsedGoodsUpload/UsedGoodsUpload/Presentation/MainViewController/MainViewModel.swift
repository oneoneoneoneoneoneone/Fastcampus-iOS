//
//  MainViewModel.swift
//  UsedGoodsUpload
//
//  Created by hana on 2022/09/27.
//

import UIKit
import RxCocoa
import RxSwift

struct MainViewModel{
    let titleTextFieldCellViewModel = TitleTextFieldCellViewModel()
    let priceTextFieldCellViewModel = PriceTextFieldCellViewModel()
    let detailWriteFormCellViewModel = DetailWriteFormCellViewModel()
    
    //뷰모델 -> 뷰
    let cellData: Driver<[String]>                  //메인뷰가 가지고있는
    let presentAlert: Signal<Alert>                 //알럿을 띄워야한다는 시그널 (이벤트)
    let push: Driver<CategoryViewModel>             //카테고리를 누르면 디테일을 보여주는 뷰컨트롤러로 푸쉬. 바인딩할수잇는 드라이버
    
    //뷰 -> 뷰모델
    let itemSelected = PublishRelay<Int>()          //아이템이 선택됨. row?
    let submitButtonTapped = PublishRelay<Void>()   //제출완 선택
    
    init(model: MainModel = MainModel()){
        //스트링을 드라이버로 전달하는데, 플레이스홀더/타이틀로 구분
        let title = Observable.just("글 제목")
        let categoryViewModel = CategoryViewModel()
        let category = categoryViewModel
            .selectedCategory
            .map{$0.name}
            .startWith("카테고리 선택")
        let price = Observable.just(" 가격 (선택사항)")
        let detail = Observable.just("내용을 입력하세요")
        
        //셀데이타.. 묶어서 어레이로setAlert
        self.cellData = Observable
            .combineLatest(title, category, price, detail) { [$0, $1, $2, $3] }
            .asDriver(onErrorJustReturn: [])
    
        let titleMessage = titleTextFieldCellViewModel
            .titleText
            .map{$0?.isEmpty ?? true}
            .startWith(true)    //그냥.. 초기값..
            .map{$0 ? ["제목을 입력해주세요"] : []}
    
        let categoryMessage = categoryViewModel
            .selectedCategory
            .map{ _ in false}   //선택된 카테고리가 잇으면 false
            .startWith(true)
            .map{$0 ? ["카테고리를 선택해주세요"] : []}
        
        let detailMessage = detailWriteFormCellViewModel
            .contentValue
            .map{$0?.isEmpty ?? true}
            .startWith(true)
            .map{$0 ? ["내용을 입력해주세요"] : []}
        
        //에러메시지를 합친 것
        let errorMessage = Observable
            .combineLatest(titleMessage,categoryMessage, detailMessage) {$0 + $1 + $2}
        
        
        //알럿을 언제 프린트할제. 제줄할때
        self.presentAlert = submitButtonTapped
        //탭이벤트가 트리거가 되어,,, 조건이 맞으면 에러메시지 방출
            .withLatestFrom(errorMessage)
        //알럿메시지 셋팅
            .map(model.setAlert)
            .asSignal(onErrorSignalWith: .empty())
        
        
        //푸싀는 카테고리용. 디테일뷰에서 카테고리가 선택되면 로우를 모델로 맵핑
        self.push = itemSelected
            .compactMap{row -> CategoryViewModel? in
                //??????????????? 로우가 1일때만.?
                guard case 1 = row else{
                    return nil
                }
                return categoryViewModel
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
