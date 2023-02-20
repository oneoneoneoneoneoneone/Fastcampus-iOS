//
//  StationSearchViewController.swift
//  SubwayStation
//
//  Created by hana on 2022/07/13.
//

import Alamofire
import SnapKit
import UIKit

class StationSearchViewController: UIViewController {
    private var stations: [Station] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        setTableViewLayout()
    }
    
    private func setNavigationItem(){
        //UInavigationItem > UISearchController >UISearchBar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철 역을 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false //searchController가 실행됐을 때 아래 배경을 어둡게 표시하는 여부 (자동검색을 사용 안할때..)
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
    }
    
    private func setTableViewLayout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }

    private func requestStationName(from stationName: String){
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")      //addingPercentEncoding - url인코딩 (한글일때,,)
            .responseDecodable(of: StationResponseModel.self){ [weak self] response in      //비동기 처리 방법(클로저, 코드블럭) - 가져온 정보를 기다리지 않고 프린트 등 사용할 수 있음
                guard
                    let self = self,                                                        //클로저안에서 self 사용시 [weak self], self? or let self = self 처리
                    case .success(let data) = response.result else {return}
                
                self.stations = data.stations
                
                self.stations = self.stations.filter({
                    $0.stationName == self.stations.first.stationName
                })
                
                self.tableView.reloadData()
            }
            .resume()
    }
}

//Delegate 특정 이벤트에 대한 동작을 위임하는 프로토콜
extension StationSearchViewController: UISearchBarDelegate{
    //검색창 입력 시작
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.reloadData()
        tableView.isHidden = false
    }
    //검색창 입력 끝
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        stations = []
    }
    
    //유저가 한글자 입력했을 때 자동으로 호출되는 메소드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestStationName(from: searchText)
    }
}

extension StationSearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        let vc = StationDetailViewController(station: station)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StationSearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.stationName
        cell.detailTextLabel?.text = station.lineNumber
        
        return cell
    }
}
