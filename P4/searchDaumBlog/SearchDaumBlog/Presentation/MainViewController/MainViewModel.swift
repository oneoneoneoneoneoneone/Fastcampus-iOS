//
//  MainViewModel.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/22.
//

import RxSwift
import RxCocoa
import UIKit

struct MainViewModel{
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    //작성된 AlertAction을 담아서 전달할 서브젝트
    let alertActionTap = PublishSubject<MainViewController.AlertAction>()
    //메인에서 알럿 셋팅할 스트림을 정의
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()){
        let blogResult = searchBarViewModel.shouldLoadResult
        //파라미터 인자와 메소드 인자가 동일하면 클로저안써도 됨
            .flatMapLatest(model.searchBlog)
            .share()
        
        //예외처리하고 결과만 가져옴
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        //에러처리
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        //cellData 맵핑
        let cellData = blogValue
            .map(model.getBlogListCellData)
            .debug("MainViewModel - cellData")
        
        //filterView 선택 > alertSheet > type별로 액션을 구분
        let sortedType = alertActionTap
            .filter{
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)  //초기값
            .debug("MainViewModel - alertActionTap")
        
        //메인뷰의 액션으로 데이터처리 -> 리스트뷰에 값 셋팅
        //호출언제댐..
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort
            )
            .bind(to: blogListViewModel.BlogCellData)
            .disposed(by: disposeBag)
        
        
        //FilterView 정렬버튼 탭 이벤트를 작성된 typealias 형태로 전환
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTap
            .map{ _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
            .debug("MainViewModel - sortButtonTap")
        
        //에러발생시 알럿 추가
        let alertForErrorMessage = blogError
            .map {message -> MainViewController.Alert in
                return(
                    title: "으악",
                    message: "오류: \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        self.shouldPresentAlert = Observable
        //에러 메시지도 알럿 셋팅처리
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
        //??@@@@2@@@@@@@@@@@@@@@ 알럿.. 메시지 셋팅
        //alertSheetForSorting
            .asSignal(onErrorSignalWith: .empty())
            .debug("MainViewModel - shouldPresentAlert")
    }
}
