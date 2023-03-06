//
//  MockBookSearchManager.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/24.
//

import XCTest
import Stubber
@testable import BookReview

final class MockBookSearchManager: BookSearchManagerProtocol{
    var isCalledRequest = false
    
    var needToSuccessRequest = false
    
    func request(from keyword: String, completionHandler: @escaping (([Book]) -> Void)) {
        isCalledRequest = true
        
        if needToSuccessRequest{
//            Stubber.invoke(request, args: escaping(keyword, completionHandler))
            completionHandler([])
        }
    }
}
