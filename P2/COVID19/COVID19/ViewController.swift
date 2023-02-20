//
//  ViewController.swift
//  COVID19
//
//  Created by hana on 2022/05/26.
//

import UIKit
import Charts
import Alamofire

//pod 파일에 Alamofire 추가
//https://github.com/Alamofire/Alamofire/blob/master/README.md
//Corona-19-/API
//https://github.com/dhlife09/Corona-19-API?utm_source=keygen-email
class ViewController: UIViewController {

    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        //completionHandler는 메인스레드에서 동작
        self.fetchCovidOverview(completionHandler: {[weak self] result in
            guard let self = self else {return}
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            
            switch result {
            case let .success(result):
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverviewList: covidOverviewList)
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) -> [CovidOverview]{
        return[
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.gangwon,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.jeonbuk,
            cityCovidOverview.jeonnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    //파일차트 앤트리에 데이터를 추가, 맵핑
    func configureChartView(covidOverviewList: [CovidOverview]){
        self.pieChartView.delegate = self
        let entries = covidOverviewList.compactMap{[weak self] overview -> PieChartDataEntry? in
           guard let self = self else {return nil}
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label:overview.countryName,
                data:overview)
        }
    
    //차트에 적용
    let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .white
        dataSet.valueTextColor = .white
        dataSet.xValuePosition = .outsideSlice
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        dataSet.colors = ChartColorTemplates.vordiplom() +
                        ChartColorTemplates.joyful() +
                        ChartColorTemplates.liberty() +
                        ChartColorTemplates.pastel() +
                        ChartColorTemplates.material()
        
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle - 30)
    }
    
    //string -> double
    func removeFormatString(string: String) -> Double{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }

    //라벨 표시
    func configureStackView(koreaCovidOverview: CovidOverview){
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
    }
    
    //api 호출, 데이터 요청하는 completionHandler/ 결과 처리
    //이스케이핑 함수를 써야 함수 밖에서도 사용할 수 있음 - 비동기작업을 하는 경우 서버 응답이 언제 올지 모르기 때문
    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void){
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = ["serviceKey": "fQWXyYZ57MsL2Cl16oJPuOTmg4xiqEF38"]
    
        AF.request(url, method: .get, parameters: param)
        //응답데이터를 받을 수 있는 메소드를 채인징 함
            .responseData(completionHandler: {response in
                switch response.result{
                case let .success(data):    //응답받은 데이터 변수
                    do{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    }catch{
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
            }
                
                
            })
    }


}

extension ViewController: ChartViewDelegate{
    //차트에서 항목을 선택할때 호출되는 메소드. 앤트리, 메소드
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else {return}
        guard let covidOverview = entry.data as? CovidOverview else {return}
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
