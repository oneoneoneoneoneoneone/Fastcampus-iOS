//
//  MockUserDefaultsManager.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/21.
//

import XCTest
@testable import BookReview

final class MockUserDefaultsManager: UserDefaultsManagerProtocol{
    var isCalledGetReviews = false
    var isCalledSetReviews = false
    
    func getReviews() -> [BookReview] {
        isCalledGetReviews = true
        
        return []
    }
    
    func setReview(_ newValue: BookReview) {
        isCalledSetReviews = true
    }
}
