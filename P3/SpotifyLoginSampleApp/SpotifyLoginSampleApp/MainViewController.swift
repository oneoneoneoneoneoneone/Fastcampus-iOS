//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by hana on 2022/06/14.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController{
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        //로그인했을 경우, 사용자의 이메일을 가져옴
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
    }
    
    @IBAction func logoutButtonTap(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do{
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError{
            print("ERROR: signout \(signOutError.localizedDescription)")
        }
         
    }
}
