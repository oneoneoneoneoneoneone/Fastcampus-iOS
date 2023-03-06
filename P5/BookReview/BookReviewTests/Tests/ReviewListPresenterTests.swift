//
//  ReviewListPresenterTests.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/16.
//

import XCTest
@testable import BookReview

final class ReviewListPresenterTests: XCTestCase {
    var sut: ReviewListPresenter!
    var viewController: MockReviewListViewController!
    var userDefaultsManager: MockUserDefaultsManager!
    
    //테스트 메소드가 불릴 때
    override func setUp() {
        super.setUp()
        
        viewController = MockReviewListViewController()
        userDefaultsManager = MockUserDefaultsManager()
        sut = ReviewListPresenter(viewController: viewController, userDefaultsManager: userDefaultsManager)
    }
    
    //테스트 메소드가 끝날 때
    override func tearDown() {
        sut = nil
        viewController = nil
        userDefaultsManager = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad_호출될_때(){
        sut.viewDidLoad()
        //presenter.viewDidLoad() 호출시 실행되어야하는 메소드 호출여부 확인
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_viewWillAppear_호출될_때(){
        sut.viewWillAppear()
        
        XCTAssertTrue(userDefaultsManager.isCalledGetReviews)
        XCTAssertTrue(viewController.isCalledReloadTableView)
    }
    
    func test_didtapRightBarButtonItem_호출될_때(){
        sut.didtapRightBarButtonItem()
        
        XCTAssertTrue(viewController.isCalledPresentToReviewWriteViewController)
    }
}
