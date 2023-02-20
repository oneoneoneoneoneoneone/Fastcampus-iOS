//
//  SeguePushViewController.swift
//  exampleProject
//
//  Created by hana on 2022/02/01.
//

import UIKit

class SeguePushViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var name : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = name{
            self.nameLabel.text = name
            
        }
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
