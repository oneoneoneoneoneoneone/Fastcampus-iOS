//
//  UserDefaultsManager.swift
//  BookReview
//
//  Created by hana on 2023/02/20.
//

import Foundation

//테스트를 위한 프로토콜 기반
protocol UserDefaultsManagerProtocol{
    func getReviews() -> [BookReview]
    func setReview(_ newValue: BookReview)
}

struct UserDefaultsManager: UserDefaultsManagerProtocol{
    enum Key: String{
        case review
    }
    
    func getReviews() -> [BookReview] {
        guard let data = UserDefaults.standard.data(forKey: Key.review.rawValue) else {return []}
        
        return(try? PropertyListDecoder().decode([BookReview].self, from: data)) ?? []
    }
    
    
    func setReview(_ newValue: BookReview) {
        var currentReviews: [BookReview] = getReviews()
        currentReviews.insert(newValue, at: 0)
        
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(currentReviews), forKey: Key.review.rawValue)
    }
    
    
}
