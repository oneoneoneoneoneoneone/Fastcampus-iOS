//
//  MockReviewListViewController.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/21.
//

import XCTest
@testable import BookReview

//프레젠트 메소드가 뷰컨트롤러에서 원하는 타이밍에 불려졌는지 판단
final class MockReviewListViewController: ReviewListProtocol{
    //메소드 호출여부 확인
    var isCalledSetupNavigationBar = false
    var isCalledSetupViews = false
    var isCalledPresentToReviewWriteViewController = false
    var isCalledReloadTableView = false
    
    func setupNavigationBar() {
        isCalledSetupNavigationBar = true
    }
    
    func setupViews() {
        isCalledSetupViews = true
    }
    
    func presentToReviewWriteViewController() {
        isCalledPresentToReviewWriteViewController = true
    }
    
    func reloadTableView() {
        isCalledReloadTableView = true
    }
}
