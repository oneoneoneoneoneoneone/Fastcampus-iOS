//
//  AlertListViewController.swift
//  Drink
//
//  Created by hana on 2022/06/17.
//

import UIKit
import NotificationCenter

class AlertListViewController: UITableViewController{
    var alerts: [Alert] = []
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alerts = alertList()
    }
    
    @IBAction func addAlertButtonAction(_ sender: UIBarButtonItem) {
        guard let addAlertVC = storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else {return}
        
        //저장할 데이터
        addAlertVC.pickedDate = {[weak self] date, isRepeat, duration in
            guard let self = self else {return}
            
            var alertList = self.alertList()
            //let dateformat = (self.setTimeFormat(date: date)) as? Date
            
            let newAlert = Alert(date: date, isOn: true, isRepeat: isRepeat, duration: duration)
        
            alertList.append(newAlert)
            alertList.sort {$0.date < $1.date}
            
            //datepiker 적용
            self.alerts = alertList
            //내부저장소 저장
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            //센터에 알림에 추가
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
            print(newAlert)
            
            self.tableView.reloadData()
        }
        
        self.present(addAlertVC, animated: true, completion: nil)
    }
    
    private func dateFormat(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        formatter.locale = Locale(identifier: "en_KR")
        formatter.timeZone =  TimeZone.current
        return formatter.string(from: date)
    }
    
    //user defuatl(내부저장소), tag로 메인에 값 전달, 저장
    func alertList() ->[Alert]{
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else {return []}
        return alerts
    }
}

//UITableview Datasource, Delegate
extension AlertListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableViNew: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0: return " 물 마실 시간"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else {return UITableViewCell()}
        
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridemLabel.text = alerts[indexPath.row].meridiem
        
        //cell에 alertSwitch가 태그 값을 가짐(indexPath)
        cell.alertSwitch.tag = indexPath.row
        
        return cell
    }
    
    //셀 높이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //editingstyle 수정 가능
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //editingstyle - 삭제 구현 commit
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            //나가지 않은 알림 삭제 removePending
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            self.alerts.remove(at: indexPath.row)
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            self.tableView.reloadData()
        default: break
        }
    }
}
