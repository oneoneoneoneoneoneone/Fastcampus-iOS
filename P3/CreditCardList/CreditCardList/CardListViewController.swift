//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by hana on 2022/06/15.
//

import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseFirestore
import CoreMedia

//UITableViewController
//델리게이트, 데이터 소스를 기본 선언 됨, 루트뷰를 UITableView로 가짐
class CardListViewController: UITableViewController {
    
    //firebase realtime database 루트 레퍼런스
    var ref: DatabaseReference!
    //Firestore 초기화
    var db = Firestore.firestore()
    
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        //** realtime 데이터베이스 읽기
        ref = Database.database().reference()
        
        //레퍼런스가 바라보는 값, 스냅샷 발생
        ref.observe(.value) {[weak self] snapshot in
            //스냅샷의 타입은 딕셔너리 (실시간 데이터를 레퍼런스에서 지켜보다가 스냅샷이라는 객체로 전달. 가공-타입지정-하여 처리)
            guard let value = snapshot.value as? [String: [String: Any]] else {return}

            do{
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)

                let cardList = Array(cardData.values)
                self?.creditCardList = cardList.sorted{ $0.rank < $1.rank }

                //테이블 뷰 리로드는 ui, 메인스레드에서 액션 처리
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }catch let error{
                print("Error JSON parsing \(error)")
            }
        }
        
        //** Firestore 읽기
        db.collection("creditCardList").addSnapshotListener{ snapshot, error in
            //snapshot에 document가 있는지 확인
            guard let documents = snapshot?.documents else{
                print("ERROR : \(String(describing: error))")
                return
            }
                
            //객체 리스트로 가져오기
            //compactMap - documents가 nil 값 반화해도 배열에 저장하지 않음. 옵셔널처리
            self.creditCardList = documents.compactMap{doc -> CreditCard? in
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: doc.data(), options: [])
                    let creditCard = try JSONDecoder().decode(CreditCard.self, from: jsonData)
                    return creditCard
                } catch let error{
                    print("ERROR JSON Parsing \(error)")
                    return nil
                }
            }.sorted{$0.rank < $1.rank}
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL =  URL(string: creditCardList[indexPath.row].cardImageURL)
        //Kingfisher - 이미지 url로 가져올 때
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //탭했을 때 동작하는 델리게이트 didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //상세화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else {return}
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        let cardID = creditCardList[indexPath.row].id
        //** realtime 데이터베이스 쓰기
        //데이터 경로를 앎 - 데이터베이스 경로(아이디/isselected)에 값 추가
        ref.child("Item\(cardID)/isSeleted").setValue(true)
        
        //키값이 분명하지 않을 때 - 컴포넌트값(id=ex인 객체)을 검색해서 객체 스냅샷을 가져옴
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: Any]],
                  let key = value.keys.first else {return}

            self.ref.child("\(key)/isSelected").setValue(true)
        }
        
        //** Firestore 쓰기
        //데이터 경로를 앎 - 콜렉션, 문서의 id
        db.collection("creditCardList").document("card\(cardID)").updateData(["isSelected": true])
        
        //키값이 분명하지 않을 때 - 컴포넌트값(id=ex인 객체)을 검색(whereField)해서 문서 업뎃
        db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments{ snapshot, _ in
            guard let document = snapshot?.documents.first else{
                print("ERROR: Firestore ..")
                return
            }
            document.reference.updateData(["isSelected": true])
        }
        
    }
    
    //모션 canEditRowAt
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let cardID = creditCardList[indexPath.row].id
                
            //** realtime 데이터베이스 삭제
            //데이터 경로를 알 때 삭제 - removeValue() 메소드
            ref.child("Item\(cardID)").removeValue()
            
            //데이터 경로를 알 수 없을 때 삭제 - 수정값을 nil로 업데이트
            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
                guard let self = self,
                      let value = snapshot.value as? [String: [String: Any]],
                      let key = value.keys.first else {return}

                self.ref.child(key)
            }
                            
            //** Firestore 쓰기
            //데이터 경로를 알 때 삭제 - removeValue() 메소드
            db.collection("creditCardList").document("card\(cardID)").delete()
            
            
            //데이터 경로를 알 수 없을 때 삭제 - 수정값을 nil로 업데이트
            db.collection("creditCardList").whereField("id", isEqualTo: cardID).getDocuments{ snapshot, _ in
                guard let document = snapshot?.documents.first else{
                    print("ERROR: Firestore ..")
                    return
                }
                document.reference.delete()
            }
        }
    }
}
