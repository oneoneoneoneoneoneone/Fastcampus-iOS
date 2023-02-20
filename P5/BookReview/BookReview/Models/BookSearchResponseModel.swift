//
//  BookSearchResponseModel.swift
//  BookReview
//
//  Created by hana on 2023/02/17.
//

import Foundation

struct BookSearchResponseModel: Decodable{
    var items: [Book] = []
}
