//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by hana on 2022/06/14.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController{
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    let signInConfig = GIDConfiguration.init(clientID: ['id'])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigation bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
        //google sing in (web view)
        GIDSignIn.sharedInstance?.presentingViewController = self
        
    }
    
    @IBAction func googleLoginButtonTap(_ sender: UIButton) {
        //GIDSignIn.sharedInstance.signIn()
        GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: self){user, error in
            guard error == nil else {return}
            guard let user = user else {return}
            
            user.authentication.do([self] authentication, error in
                                   guard error == nil else {return}
                                   guard let authentication = authentication else {return}
                                   
                                   let idToken = authentication.idToken
        }
    }
    @IBAction func appleLoginButtonTap(_ sender: UIButton) {
    }
}
