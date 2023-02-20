//
//  UNNotificationCenter.swift
//  Drink
//
//  Created by hana on 2022/06/17.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter{
    //알럿이 켜지면 요청이 추가됨
    func addNotificationRequest(by alert: Alert){
        let content = UNMutableNotificationContent()
        
        content.title = "물 마실 시간이용"
        content.body = "물을 마셔야합니다."
        content.sound = .default
        content.badge = 1        //생성된 뱃지는 SceneDelegate에서 없앰
        
        //트리거 설정
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        //UNUserNotificationCenter에 추가
        self.add(request, withCompletionHandler: nil)
        UserDefaults
        
        if(alert.isRepeat){
            let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: alert.duration, repeats: false)
            let timeRequest = UNNotificationRequest(identifier: alert.id, content: content, trigger: timeTrigger)
            
            self.add(timeRequest, withCompletionHandler: nil)
        }
    }
    
}
