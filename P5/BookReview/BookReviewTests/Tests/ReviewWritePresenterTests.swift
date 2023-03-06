//
//  ReviewWritePresenterTests.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/21.
//

import XCTest
@testable import BookReview

final class ReviewWritePresenterTests: XCTestCase {
    var sut: ReviewWritePresenter!
    var viewController: MockReviewWriteViewController!
    var userDefaultsManager: MockUserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockReviewWriteViewController()
        userDefaultsManager = MockUserDefaultsManager()
        sut = ReviewWritePresenter(viewController: viewController, userDefaultsManager: userDefaultsManager)
    }
    
    override func tearDown() {
        sut = nil
        viewController = nil
        userDefaultsManager = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad_호출될_때(){
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.calledSetupNavigationBar)
        XCTAssertTrue(viewController.calledSetupViews)
    }
    
    func test_didTapLeftBarButton_호출될_때(){
        sut.didTapLeftBarButton()
        
        XCTAssertTrue(viewController.calledShowCloseAlertController)
    }
    
    func test_didTapRightBarButton_호출될_때_contentsText이_nill(){
        sut.book = Book(title: "Swift", image: "")
        sut.didTapRightBarButton(contentsText: sut.contentsTextViewPlaceHolderText)
        
        XCTAssertFalse(userDefaultsManager.isCalledSetReviews)
        XCTAssertFalse(viewController.calledClose)
    }
    
    func test_didTapRightBarButton_호출될_때_Book이_nill(){
        sut.book = nil
        sut.didTapRightBarButton(contentsText: "ㅎㅎ")
        
        XCTAssertFalse(userDefaultsManager.isCalledSetReviews)
        XCTAssertFalse(viewController.calledClose)
    }
    
    func test_didTapRightBarButton_호출될_때_Book_contentsText이_nill이_아님(){
        sut.book = Book(title: "Swift", image: "")
        sut.didTapRightBarButton(contentsText: "ㅎㅎ")
        
        XCTAssertTrue(userDefaultsManager.isCalledSetReviews)
        XCTAssertTrue(viewController.calledClose)
    }
    
    func test_didTapbookTitleButton_호출될_때(){
        sut.didTapbookTitleButton()
        
        XCTAssertTrue(viewController.calledShowSearchBookViewController)
    }
    
    func test_selectBook_호출될_때(){
        let book = Book(title: "Swift", image: "")
        sut.selectBook(book)
        
        XCTAssertTrue(viewController.calledUpdateViews)
    }
}
