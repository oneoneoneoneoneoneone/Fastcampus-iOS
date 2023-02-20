//
//  ReviewListPresenter.swift
//  BookReview
//
//  Created by hana on 2023/02/16.
//

import UIKit

//delegate 패턴 - viewcontroller에서 실행할 동작 구현
//뷰는 동작 알림, 프레젠터는 명령.. 뷰에서 다 시 실행..
protocol ReviewListProtocol{
    func setupNavigationBar()
    func setupViews()
    func presentToReviewWriteViewController()
    func reloadTableView()
}

final class ReviewListPresenter: NSObject{
    private let viewController: ReviewListProtocol
    private let userDefaultsManager = UserDefaultsManager()
    
    private var review: [BookReview] = []
    
    init(viewController: ReviewListProtocol){
        self.viewController = viewController
    }
    
    func viewDidLoad(){
        viewController.setupNavigationBar()
        viewController.setupViews()
    }
    
    func viewWillAppear(){
        review = userDefaultsManager.getReviews()
        
        viewController.reloadTableView()
    }
    
    func didtapRightBarButtonItem(){
        viewController.presentToReviewWriteViewController()
    }
}

extension ReviewListPresenter: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        review.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let review = review[indexPath.row]
        cell.textLabel?.text = "\(review.title)"
        cell.detailTextLabel?.text = "\(review.contents)"
        //completeHandler(이미지를 가져온 후) setNeedsLayout(한번 더 레이아웃을 그림)
        cell.imageView?.kf.setImage(with: review.imageURL, placeholder: .none){_ in
            cell.setNeedsLayout()
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}
