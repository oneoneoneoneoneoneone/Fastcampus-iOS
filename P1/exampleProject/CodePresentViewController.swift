//
//  CodePresentViewController.swift
//  exampleProject
//
//  Created by hana on 2022/02/01.
//

import UIKit

protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name : String?
    //프로토콜 타입 변수, weak 강한순환참조? 방지.. 메모리 누수 방지..
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = name {
            self.nameLabel.text = name
        }
        
        var higit = "hi";
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        //데이터를 받는쪽에서 위임받음
        self.delegate?.sendData(name: "Gunter")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
