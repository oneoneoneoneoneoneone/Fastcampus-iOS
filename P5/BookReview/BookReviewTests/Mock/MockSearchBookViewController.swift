//
//  MockSearchBookViewController.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/24.
//

import XCTest
@testable import BookReview

class MockSearchBookViewController: SearchBookProtocol{
    var isCalledSetupNavigationBar = false
    var isCalledSetupViews = false
    var isCalledClose = false
    var isCalledReloadView = false
    
    func setupNavigationBar() {
        isCalledSetupNavigationBar = true
    }
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func close() {
        isCalledClose = true
    }
    
    func reloadView() {
        isCalledReloadView = true
    }
    
    
}
