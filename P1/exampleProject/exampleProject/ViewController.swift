//
//  ViewController.swift
//  exampleProject
//
//  Created by hana on 2022/01/18.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {
    //@IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tabCodePushButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController //type class parse
        else { return }
        
        viewController.name = "Gunter"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapCodePresentButton(_ sender: UIButton) {
        //인스턴트화
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CodePresentViewController") as? CodePresentViewController else {return}
        
        viewController.modalPresentationStyle = .fullScreen
        viewController.name = "Gunter"
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    //세그웨이 실행 직전 자동 호출
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //전환하려는 뷰컨트롤러의 인스턴트를 가져옴
        if let viewController =  segue.destination as? SeguePushViewController {
            viewController.name = "Gunter"
        }
    }
    
    func sendData(name : String){
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
    }
    
    //    @IBAction func tapChangeColorButton(_ sender: UIButton) {
//        self.colorView.backgroundColor = UIColor.blue
//        print("색상 변경 되었습니다")
//    }
}

