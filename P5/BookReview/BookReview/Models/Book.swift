//
//  Book.swift
//  BookReview
//
//  Created by hana on 2023/02/17.
//

import Foundation

struct Book: Decodable{
    let title: String
    private let image: String?
    
    var imageURL: URL? {URL(string: image ?? "")}
}
