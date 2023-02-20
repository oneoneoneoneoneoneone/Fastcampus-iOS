//
//  Alert.swift
//  Drink
//
//  Created by hana on 2022/06/17.
//

import Foundation

struct Alert: Codable{
    var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool
    var isRepeat: Bool
    let duration: Double
    
    var time: String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
//        timeFormatter.locale = Locale(identifier: "en_KR")
//        timeFormatter.timeZone =  TimeZone.current
        
        return timeFormatter.string(from: date)
    }
    
    var meridiem: String{
        let meridiemFormatter = DateFormatter()
        meridiemFormatter.dateFormat = "a"
        meridiemFormatter.locale = Locale(identifier: "ko")
//        meridiemFormatter.timeZone =  TimeZone.current
        return meridiemFormatter.string(from: date)
        
    }
    
}
