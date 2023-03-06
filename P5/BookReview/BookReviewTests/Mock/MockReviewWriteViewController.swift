//
//  MockReviewWriteViewController.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/21.
//

import XCTest
@testable import BookReview

final class MockReviewWriteViewController: ReviewWriteProtocol{
    var calledSetupNavigationBar = false
    var calledShowCloseAlertController = false
    var calledClose = false
    var calledSetupViews = false
    var calledShowSearchBookViewController = false
    var calledUpdateViews = false
    
    func setupNavigationBar() {
        calledSetupNavigationBar = true
    }
    
    func showCloseAlertController() {
        calledShowCloseAlertController = true
    }
    
    func close() {
        calledClose = true
    }
    
    func setupViews() {
        calledSetupViews = true
    }
    
    func showSearchBookViewController() {
        calledShowSearchBookViewController = true
    }
    
    func updateViews(title: String, imageUrl: URL?) {
        calledUpdateViews = true
    }
}
