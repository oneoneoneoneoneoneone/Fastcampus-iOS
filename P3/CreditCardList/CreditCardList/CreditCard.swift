//
//  CreditCard.swift
//  CreditCardList
//
//  Created by hana on 2022/06/15.
//

import Foundation

struct CreditCard: Codable{
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool?
}

struct PromotionDetail: Codable{
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
