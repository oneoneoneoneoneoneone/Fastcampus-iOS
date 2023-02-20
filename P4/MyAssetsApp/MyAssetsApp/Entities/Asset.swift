//
//  Asset.swift
//  MyAssetsApp
//
//  Created by hana on 2022/07/08.
//

import Foundation

//ObservableObject - 외부에서 별도 데이터 모델을 이용해서 데이터를 디코딩 후 뷰에 표시
class Asset: Identifiable, ObservableObject, Decodable{
    let id: Int
    let type: AssetMenu
    let data: [AssetData]
    
    init(id: Int, type: AssetMenu, data: [AssetData]){
        self.id = id
        self.type = type
        self.data = data
    }
}

class AssetData: Identifiable, ObservableObject, Decodable{
    let id: Int
    let title: String
    let amount: String
    let creditCardAmounts: [CreditCardAmounts]?
    
    init(id: Int, title: String, amount: String, creditCardAmounts: [CreditCardAmounts]? = nil){
        self.id = id
        self.title = title
        self.amount = amount
        self.creditCardAmounts = creditCardAmounts
    }
}

enum CreditCardAmounts: Identifiable, Decodable{
    case previousMonth(amount: String)
    case currentMonth(amount: String)
    case nextMonth(amount: String)
    
    var id: Int{
        switch self{
        case .previousMonth:
            return 0
        case .currentMonth:
            return 1
        case .nextMonth:
            return 2
        }
    }
    
    var amount: String{
        switch self{
        case .previousMonth(let amount),
             .currentMonth(let amount),
             .nextMonth(let amount):
            return amount
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case previousMonth
        case currentMonth
        case nextMonth
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode(String.self, forKey: .previousMonth){
            self = .previousMonth(amount: value)
            return
        }
        if let value = try? values.decode(String.self, forKey: .currentMonth){
            self = .currentMonth(amount: value)
            return
        }
        if let value = try? values.decode(String.self, forKey: .nextMonth){
            self = .nextMonth(amount: value)
            return
        }
        
        throw fatalError("ERROR: JSON Decoding")
    }
}
