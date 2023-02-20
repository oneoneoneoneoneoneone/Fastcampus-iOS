//
//  NoticeViewController.swift
//  Notice
//
//  Created by hana on 2022/06/16.
//

import UIKit

class NoticeViewController: UIViewController {
    //ViewController로 부터 원격 정보를 받아와 처리
    var noticeContants: (title: String, detail: String, date: String)?
    
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //팝업 모양 - 라운드
        noticeView.layer.cornerRadius = 6
        //최상위 view 배경 색
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        guard let noticeContants = noticeContants else { return }
        titleLabel.text = noticeContants.title
        detailLabel.text = noticeContants.detail
        dateLabel.text = noticeContants.date
    }
    
    @IBAction func doneButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
