//
//  WeatherInformation.swift
//  Weather
//
//  Created by hana on 2022/05/25.
//

import Foundation

struct WeatherInformation: Codable //자기를 변환하거나 외부표현(json)으로 변환하는 타입 - 타입 디코딩&인코딩
{
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey{
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable{
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    //json 자료명과 변수 명이 일치하지 않을 때 맵핑
    enum CodingKeys: String, CodingKey{
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
