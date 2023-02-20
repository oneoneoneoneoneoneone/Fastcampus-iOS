//
//  BearListViewController.swift
//  Brewery
//
//  Created by hana on 2022/06/21.
//

import UIKit

class BeerListViewController: UITableViewController{
    var beerList = [Beer]()
    var dataTasks = [URLSessionDataTask]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UINavigationBar
        title="브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        //페이징
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
        
    }
}

extension BeerListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else {return UITableViewCell()}
                
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewController = BeerDetailViewController()
        
        detailViewController.beer = selectedBeer
        self.show(detailViewController, sender: nil)
    }
}

extension BeerListViewController: UITableViewDataSourcePrefetching{
    //화면 외에 보여질 예정의 로우
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard currentPage != 1 else {return}
        indexPaths.forEach{
            if($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}
 
//data Fetching
private extension BeerListViewController{
    func fetchBeer(of page: Int){
        //task in task == $0
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
              //기존에 호출된 url인지 dataTasks에서 확인. 새롭게 요청된 url 일때만 호출
              dataTasks.firstIndex(where: {$0.originalRequest?.url == url }) == nil
              else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        //completionHandler: data, response, error
        let dataTask = URLSession.shared.dataTask(with: request){[weak self] data, response, error in
            //응답받은 리스폰스 핸들링
            guard error == nil,
                  let self = self,
                  let response = response as? HTTPURLResponse,
                  let data = data,
                  let beers = try? JSONDecoder().decode([Beer].self, from: data) else{
                print("ERROR: \(error?.localizedDescription ?? "" )")
                return
            }
            
            switch response.statusCode{
            case(200...299) :
                self.beerList += beers //받아온 데이터를 리스트에 추가
                self.currentPage += 1
                
                //UItableView는 메인에서 실행
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case(400...499):
                print("""
                    ERROR: Client ERROR \(response.statusCode)
                    Response: \(response)
                    """)
            case(500...599):
                print("""
                    ERROR: Server ERROR \(response.statusCode)
                    Response: \(response)
                    """)
            default:
                print("""
                    ERROR: \(response.statusCode)
                    Response: \(response)
                    """)
            }
        }
        dataTask.resume()
    }
}
