//
//  AppDelegate.swift
//  CreditCardList
//
//  Created by hana on 2022/06/15.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        
        //FirebaseFirestoreSwift - 더미데이터를 josn 형태로 firebaseDatabase 에 쓸 수 있음 (문서-)
        //firebaseFirestore Database 실시간 x
        //데이터베이스에 최초 쓰기만 수행하는 코드
        let db = Firestore.firestore()
        
        //db가 비어있을 때만 배치로 객체 저장
        db.collection("creditCardList").getDocuments {snapshot, _ in
            guard snapshot?.isEmpty == true else {return}
            let batch = db.batch()
            
            let card0Ref = db.collection("creditCardList").document("card0")
            let card1Ref = db.collection("creditCardList").document("card1")
            let card2Ref = db.collection("creditCardList").document("card2")
            let card3Ref = db.collection("creditCardList").document("card3")
            
            do{
                //배치를 통해서 firestore에 CreditCardDummy를  저장함
                try batch.setData(from: CreditCardDummy.card0, forDocument: card0Ref)
                try batch.setData(from: CreditCardDummy.card1, forDocument: card1Ref)
                try batch.setData(from: CreditCardDummy.card2, forDocument: card2Ref)
                try batch.setData(from: CreditCardDummy.card3, forDocument: card3Ref)
            }catch let error{
                print("Error Firestore \(error)")
            }
            
            batch.commit()
        }
                
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

