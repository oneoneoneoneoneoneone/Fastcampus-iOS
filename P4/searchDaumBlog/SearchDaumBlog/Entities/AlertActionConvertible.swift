//
//  AlertActionConvertible.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/07.
//

import UIKit

protocol AlertActionConvertible{
    var title: String { get }
    var style: UIAlertAction.Style { get }
}
