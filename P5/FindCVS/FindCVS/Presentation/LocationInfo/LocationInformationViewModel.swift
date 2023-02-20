//
//  LocationInformationViewModel.swift
//  FindCVS
//
//  Created by hana on 2022/09/28.
//

import RxSwift
import RxCocoa

struct LocationInformationViewModel{
    let disposeBag = DisposeBag()
    
    //subViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    //viwModel -> view
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>    //외부(API)에서 전달받을 값
    let scrollToSelectedLocation: Signal<Int>               //지도의 pointitem을 테이블리스트에 반영하기 위한 식별값 Int..
    
    //view -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()        //리스트가 선택되었을 때 row 값 (index)
    
    private let documentData = PublishSubject<[KLDocument]>()      //셀에 뿌려줄 api로 받아온 정형화 된 리스트
    
    init(model: LocationInformationModel = LocationInformationModel()){
        //MARK: 네트워크 통신으로 데이터 불러오기
        
        //뷰에서 센터값이 넘어올때마다(델리게이트), API통신을 태움
        let cvsLocationDataResult = mapCenterPoint
        //flatMapLatest ?? 왜 여기에 넣지????????????????????@@@@@@@@@
            .flatMapLatest(model.getLocation)
            .share()    //??
        
        //api에서 넘어온 result값에서 value만 뽑음
        let cvsLocationDataValue = cvsLocationDataResult
        //실패값을 nil처리, compactMap으로 nil 값 제거
            .compactMap{data -> LocationData? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        //api에서 넘어온 result값에서 에러가있으면 에러메시지 처리
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap{data -> String? in
                switch data{
                case let .success(data) where data.documents.isEmpty:
                    return """
                    지도 위치를 옮겨서 재검색해주세요.
                    """
                case let .failure(error):
                    return error.localizedDescription
                default:    //성공일때
                    return nil
                }
            }
        
        //LocationData(=[documentData]) 처리
        cvsLocationDataValue
            .map{$0.documents}
            .bind(to: documentData)
            .disposed(by: disposeBag)
        
        
        //MARK: 지도 중심점 설정
        
        ///cell을 선택하여 row 값이 들어왓을 때,
        let selectDetailListItem = detailListItemSelected
            //withLatestFrom: detailListItemSelected값이 들어오는게 트리거가 되어, documentData값을 방출함. 반환 형식도 Int -> KLDocument 로 변환됨
            .withLatestFrom(documentData) {$1[$0]}  //documentData[detailListItemSelected]
            .map(model.documentToMTMapPoint)
//            .map{data -> MTMapPoint in
//                guard //let data = data,
//                      let longtiue = Double(data.x),
//                      let latitude = Double(data.y) else{
//                    return MTMapPoint()
//                }
//                let geoCoord = MTMapPointGeo(latitude: latitude, longitude: longtiue)
//                return MTMapPoint(geoCoord: geoCoord)
//            }
        
        ///현위치버튼을 탭했을 때
        let moveToCurrentLocation = currentLocationButtonTapped
        //현재위치 값이 있는 상태인지 확인
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                //최초로 현위치를 받아온 시점
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = Observable
            .merge(cvsLocationDataErrorMessage, //네트워크 에러
                   mapViewError.asObservable()  //view 에러
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        //tableView에서 사용할 data 셋팅
        detailListCellData = documentData
            .map(model.documentsToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        //백그라운드 처리
        documentData
            .map{!$0.isEmpty}
            .bind(to: detailListBackgroundViewModel.shouldHideStatusLabel)
            .disposed(by: disposeBag)
        
        //지도에서 포인트아이템을 선택했을때 뷰이동, 이동된 뷰에 맞춰 테이블뷰 리스트cell을 셋팅하기 위해 row값으로 사용할 tag 전달
        scrollToSelectedLocation = selectPOIItem
            .map{$0.tag}
            .asSignal(onErrorJustReturn: 0)
    }
}
