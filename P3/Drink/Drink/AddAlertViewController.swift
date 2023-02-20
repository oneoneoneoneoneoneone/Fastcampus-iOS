//
//  AddAlertViewController.swift
//  Drink
//
//  Created by hana on 2022/06/17.
//

import UIKit

class AddAlertViewController: UIViewController{
    //부모뷰에 데이터 전달 - 옵셔널 클로저
    var pickedDate: ((_ date: Date,_ isRepeat: Bool, _ duration: Double) -> Void)?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var isRepeatSwitch: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timePicker.locale = Locale(identifier: "ko")
    }
    
    @IBAction func dismissButtonTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTap(_ sender: UIBarButtonItem) {
        pickedDate?(datePicker.date, isRepeatSwitch.isOn, datePicker.date.timeIntervalSinceNow + timePicker.countDownDuration)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isRepeatSwitchValueChanged(_ sender: UISwitch) {
        timePicker.isEnabled = sender.isOn
    }
}
