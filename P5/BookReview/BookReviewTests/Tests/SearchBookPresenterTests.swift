//
//  SearchBookPresenterTests.swift
//  BookReviewTests
//
//  Created by hana on 2023/02/24.
//

import XCTest
@testable import BookReview

final class SearchBookPresenterTests: XCTestCase{
    var sut: SearchBookPresenter!
    var viewController: MockSearchBookViewController!
    var bookSearchManager: MockBookSearchManager!
    var delegate: MockDelegate!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockSearchBookViewController()
        bookSearchManager = MockBookSearchManager()
        delegate = MockDelegate()
        
        sut = SearchBookPresenter(viewController: viewController, delegate: delegate, bookSearchManager: bookSearchManager)
    }
    
    override func tearDown() {
        sut = nil
        viewController = nil
        bookSearchManager = nil
        delegate = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad_호출될_때(){
        sut.viewDidLoad()
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupViews)
    }
    
    func test_searchBarSearchButtonClicked_호출될_때_request_성공(){
        bookSearchManager.needToSuccessRequest = true
        sut.searchBarSearchButtonClicked(UISearchBar())
        
        XCTAssertTrue(viewController.isCalledReloadView, "reloadView 실행")
    }

    func test_searchBarSearchButtonClicked_호출될_때_request_실패(){
        bookSearchManager.needToSuccessRequest = false
        sut.searchBarSearchButtonClicked(UISearchBar())
        
        XCTAssertFalse(viewController.isCalledReloadView, "reloadView 실행안됨")

    }

    func test_tableView_didSelectRowAt_호출될_때(){
        sut.books = [Book(title: "Swift", image: "")]
        sut.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(delegate.isCalledSelectBook)
        XCTAssertTrue(viewController.isCalledClose)
    }
}
