//
//  StationArrivalResponseModel.swift
//  SubwayStation
//
//  Created by hana on 2022/07/18.
//

import Foundation

struct StationArrivalResponseModel: Decodable{
    var realtimeArrivalList: [RealTimeArrival] = []
    
    struct RealTimeArrival: Decodable{
        let line: String
        let remainTime: String
        let currentStation: String
        
        enum CodingKeys: String, CodingKey{
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
        }
    }
}
