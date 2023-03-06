//
//  ReviewWritePresenter.swift
//  BookReview
//
//  Created by hana on 2023/02/16.
//

import UIKit

protocol ReviewWriteProtocol{
    func setupNavigationBar()
    func showCloseAlertController()
    func close()
    func setupViews()
    func showSearchBookViewController()
    func updateViews(title: String, imageUrl: URL?)
}

final class ReviewWritePresenter{
    private let viewController: ReviewWriteProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
//    private var book: Book?
    var book: Book?
    
    let contentsTextViewPlaceHolderText = "내용을 입력해주세요."
    
    init(viewController: ReviewWriteProtocol, userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()) {
        self.viewController = viewController
        self.userDefaultsManager = userDefaultsManager
    }
    
    func viewDidLoad(){
        viewController.setupNavigationBar()
        viewController.setupViews()
    }
    
    func didTapLeftBarButton(){
        viewController.showCloseAlertController()
    }
    
    func didTapRightBarButton(contentsText: String?){
        guard let book = self.book,
              let contentsText = contentsText,
              contentsText != contentsTextViewPlaceHolderText else {return}
    
        let bookReview = BookReview(title: book.title, contents: contentsText, imageURL: book.imageURL)
        userDefaultsManager.setReview(bookReview)
        
        viewController.close()
    }
    
    func didTapbookTitleButton(){
        viewController.showSearchBookViewController()
    }
}

extension ReviewWritePresenter: SearchBookDelegate{
    func selectBook(_ book: Book) {
        self.book = book
        viewController.updateViews(title: book.title, imageUrl: book.imageURL)
    }
}
