//
//  MockDelegate.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/24.
//

import XCTest
@testable import BookReview

final class MockDelegate: SearchBookDelegate{
    var isCalledSelectBook = false
    func selectBook(_ book: Book) {
        isCalledSelectBook = true
    }
    
    
}
