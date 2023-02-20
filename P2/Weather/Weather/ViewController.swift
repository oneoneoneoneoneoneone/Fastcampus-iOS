//
//  ViewController.swift
//  Weather
//
//  Created by hana on 2022/05/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true) //키보드 사라짐
        }
    }
    
    func configureView(weatherInformation: WeatherInformation){
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first{
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.maxTempLabel.text = "\(Int(weatherInformation.temp.maxTemp - 273.15))℃"
        self.minTempLabel.text = "\(Int(weatherInformation.temp.minTemp - 273.15))℃"
        
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=507c9e4d22da9905a4f721f042fda956") else{return}
        let session = URLSession(configuration: .default)
        //서버로 데이터 요청 {요청 데이터가 왔을 때 호출되는 컴플리션 핸들러 클로즈 정의, in 이하 절 실행}
        session.dataTask(with: url) {[weak self] data, response, error in
            let successRange = (200..<300)
            
            guard let data = data, error == nil else{return}
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                //(json 맵핑 시킬 코더블 프로토콜을 준수하는 사용자 정의 타입, json data)
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else{return}
                
                //네트워크작업은 별도 스레드에서 실행되고 메인 스레드로 돌아오지 않음
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from:data) else{return}
                
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = true
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume() //작업실행
    }
}

//즐겨찾기?
