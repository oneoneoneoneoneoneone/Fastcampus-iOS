//
//  SearchBookViewController.swift
//  BookReview
//
//  Created by hana on 2023/02/17.
//

import UIKit

final class SearchBookViewController: UIViewController{
    private lazy var presenter = SearchBookPresenter(viewController: self, delegate: serachBookDelegate)
    
    private let serachBookDelegate: SearchBookDelegate
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = presenter
        
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = presenter
        tableView.dataSource = presenter
        
        return tableView
    }()
    
    init(searchBookDelegate: SearchBookDelegate){
        self.serachBookDelegate = searchBookDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
}


extension SearchBookViewController: SearchBookProtocol{
    func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    func setupViews(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func close() {
        navigationItem.searchController?.dismiss(animated: true)
        dismiss(animated: true)
    }
    
    func reloadView(){
        tableView.reloadData()
    }
}
