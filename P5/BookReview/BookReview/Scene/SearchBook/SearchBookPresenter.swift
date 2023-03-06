//
//  SearchBookPresenter.swift
//  BookReview
//
//  Created by hana on 2023/02/17.
//

import UIKit

protocol SearchBookProtocol{
    func setupNavigationBar()
    func setupViews()
    func close()
    func reloadView()
}

///ReviewWritePresenter
protocol SearchBookDelegate{
    func selectBook(_ book: Book)
}

final class SearchBookPresenter: NSObject{
    private let viewController: SearchBookProtocol
    private let bookSearchManager: BookSearchManagerProtocol
    
    private let delegate: SearchBookDelegate
    
//    private var books: [Book] = []
    var books: [Book] = []
    
    init(viewController: SearchBookProtocol, delegate: SearchBookDelegate, bookSearchManager: BookSearchManagerProtocol = BookSearchManager()) {
        self.viewController = viewController
        self.delegate = delegate
        self.bookSearchManager = bookSearchManager
    }
    
    func viewDidLoad(){
        viewController.setupNavigationBar()
        viewController.setupViews()
    }
}


extension SearchBookPresenter: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        
        bookSearchManager.request(from: searchText){ [weak self] newBooks in
            self?.books = newBooks
            self?.viewController.reloadView()
        }
    }
}

extension SearchBookPresenter: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.row]
        delegate.selectBook(selectedBook)
        
        viewController.close()
    }
    
}
extension SearchBookPresenter: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(books[indexPath.row].title)"
        
        return cell
    }
    
    
}
