//
//  ViewController.swift
//  Notice
//
//  Created by hana on 2022/06/16.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {

    var remoteConfig: RemoteConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        //테스트를 위해 새로운 값을 패치하는 리커버를 최소화해서 최대한 자주 가져옴//개발 중 0
        setting.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getNotice()
    }
}

//RemoteConfig
extension ViewController{
    
    func getNotice(){
        guard let remoteConfig = remoteConfig else{return}
        
        //연결확인
        remoteConfig.fetch{[weak self] status, _ in
            if status == .success{
                remoteConfig.activate(completion: nil)
            }else{
                print("ERROR: ")
            }
            
            guard let self = self else {return}
            
            if !self.isNoticeHidden(remoteConfig) {
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContants = (title: title, detail: detail, date: date)
                self.present(noticeVC, animated: true, completion: nil)
            }else{
                self.showEventAlert()
            }
        }
    }
    
    //공지를 숨길지 확인
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool{
        return remoteConfig["isHidden"].boolValue
    }
}

//A/B Testing
extension ViewController{
    
    func showEventAlert() {
        guard let remoteConfig = remoteConfig else {return}
        
        remoteConfig.fetch {[weak self] status, _ in
            if status == .success {
                remoteConfig.activate(completion: nil)
            }else{
                print("Config not fetched")
            }
            
            let message = remoteConfig["message"].stringValue ?? ""
            //알럿 컨트롤러
            let confirmAction = UIAlertAction(title: "확인하기", style: .default) { _ in
                //google analytics 이벤트 기록
                Analytics.logEvent("promotion_alert", parameters: nil)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            
            let alertController = UIAlertController(title: "EVENT", message: message, preferredStyle: .alert)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //뷰컨트롤러에 띄우기
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
