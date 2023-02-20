//
//  LocationInfomationViewController.swift
//  FindCVS
//
//  Created by hana on 2022/09/28.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import SnapKit

class LocationInformationViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    let mapView = MTMapView()
    let currentLocationButton = UIButton()
    let detailList = UITableView()
    
    let detailListBackgrountView = DetailListBackgroundView()
    let viewModel = LocationInformationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: LocationInformationViewModel){
        detailListBackgrountView.bind(viewModel.detailListBackgroundViewModel)
        
        //MARK: 뷰모델 -> 뷰
        
        //받아온 MTMapPoint값을 뷰에 적용. 뷰가 이동됨
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        //tableViewCell 데이터바인딩. 리스트뿌리기
        viewModel.detailListCellData
            .drive(detailList.rx.items){tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "DetailListCell", for:IndexPath(row: row, section: 0)) as! DetailListCell
                
                cell.setData(data)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        //맵에 데이터바인딩. 맵에 포인트아이템 뿌리기
        viewModel.detailListCellData
//            .map{cellDatas in
//                cellDatas.compactMap{cellDate in
//                cellDate.point
//            }}
            .map{$0.compactMap{$0.point}}   //[datacell] -> [datacell.point]
            .drive(self.rx.addPOIItems)
            .disposed(by: disposeBag)
        
              
        viewModel.scrollToSelectedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        //MARK: 뷰 -> 뷰모델
        
        //cell 선택했을 때
        detailList.rx.itemSelected
            .map{$0.row}
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
        
        //현위치 선택했을 때
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
        
    }

    private func attribute(){
        title = "내 주변 편의점 찾기"
        view.backgroundColor = .white
            
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
        
        detailList.register(DetailListCell.self, forCellReuseIdentifier: "DetailListCell")
        detailList.separatorStyle = .none
        detailList.backgroundView = detailListBackgrountView
    }
    
    private func layout(){
        [mapView, currentLocationButton, detailList].forEach{
            view.addSubview($0)
        }
        
        mapView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        currentLocationButton.snp.makeConstraints{
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        detailList.snp.makeConstraints{
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }

}


extension LocationInformationViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse,
             .notDetermined:
            return
        default:
            viewModel.mapViewError.accept(MTMapViewError.locationAutorizationDenied.errorDescription)
            return
        }
    }
}

extension LocationInformationViewController: MTMapViewDelegate{
    //현위치를 매번 업데이트.
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
        viewModel.currentLocation.accept(location)
        #endif
    }
    
    //뷰의 이동이 끝났을 때, 화면의 센터포인트 확인
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    //핀표시된 아이템을 탭할때 해당 위치를 확인
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    //제대로된 현위치를 불러오지 못했을 때 에러처리
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}


//@@@@@@@@@먼소리고
//MTMapView 내에 메소드를 rx.인자로 쓸 수 있게!!!!!!!!!!!!
extension Reactive where Base: MTMapView{
    //[target=base].rx.메소드 << 여기에 넘길 값 타입이 point
    //base.setMapCenter 이 메소드를 rx에서 쓰기위해!!!!!!!!!!!!
    ///지도 화면의 중심점을 설정한다.
    var setMapCenterPoint: Binder<MTMapPoint>{
        //binder의 인자값을 setMapCenter에 넣는건감?
        //base가 MTMapView, point 가 값 같은뎅?
        return Binder(base) {base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}

extension Reactive where Base: LocationInformationViewController{
    ///알랏 show 셋팅
    var presentAlert: Binder<String>{
        return Binder(base) {base, message in
            let alertController = UIAlertController(title: "문제발생", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            base.present(alertController, animated: true, completion: nil)
        }
    }

    ///선택된 태그(index)에 맞춰 tableView List row update 셋팅
    var showSelectedLocation: Binder<Int>{
        return Binder(base) {base, row in
            let indexPath = IndexPath(row: row, section: 0)
            
            base.detailList.selectRow(at: indexPath, animated: true, scrollPosition: .top)  //scrollPosition - 해당 인덱스 로우가 위치할 곳
        }
    }
    
    ///좌표를 받아와서 맵에 POIItem 업데이트하기
    var addPOIItems: Binder<[MTMapPoint]>{
        return Binder(base) {base, points in
            let items = points
                .enumerated()       //방출된 요소의 인덱스를 포함한 튜플을 생성. offset은 자동 생성된 index 1,2,3,.. 구나...@@@
                .map{ offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    
                    mapPOIItem.mapPoint = point
                    mapPOIItem.markerType = .redPin
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset
                    
                    return mapPOIItem
                }
            
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
}
