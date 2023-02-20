//
//  AppDelegate.swift
//  SpotifyLoginSampleApp
//
//  Created by hana on 2022/06/14.
//

import UIKit
import Firebase
import FirebaseCore
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate{//, GIDSignInDelegate{
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //firebase 초기화
        FirebaseApp.configure()
        
        //google Sing 초기화
//        GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance.delegate = self
                
        GIDSignIn.sharedInstance.restorePreviousSignIn{user, error in
            if error != nil || user == nil{
                
            }else{
                
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //구글 인증프로세스가 끝날 때, 앱이 수신하는 url을 처리
        return GIDSignIn.sharedInstance.handle(url)

//        // Ensure the URL is a file URL
//        guard inputURL.isFileURL else { return false }
//
//        // Reveal / import the document at the URL
//        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else { return false }
//
//        documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
//            if let error = error {
//                // Handle the error appropriately
//                print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
//                return
//            }
//
//            // Present the Document View Controller for the revealed URL
//            documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
//        }
//
//        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //로그인 화면에서 구글 로그인된 값(access token)을 처리
        if let error = error{
            print("ERROR Google Sign In \(error.localizedDescription)")
            return
        }
        
        //권한 위임된 토큰으로 로그인, firebase 사용자정보 생성
        let authentication = user.authentication
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential){_, _ in
            self.showMainViewController()
        }
                
    }
    
    //메인화면 띄우기
    private func showMainViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
    }


}

