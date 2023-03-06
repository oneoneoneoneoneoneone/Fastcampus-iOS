//
//  BookSearchManager.swift
//  BookReview
//
//  Created by hana on 2023/02/17.
//

import Foundation
import Alamofire

//테스트를 위한 프로토콜 기반
protocol BookSearchManagerProtocol{
    func request(from keyword: String, completionHandler: @escaping (([Book]) -> Void))
}

struct BookSearchManager: BookSearchManagerProtocol{
    func request(from keyword: String, completionHandler: @escaping (([Book]) -> Void)){
        guard let url = URL(string: "https://openapi.naver.com/v1/search/book.json") else {return}
        
        let prameters = BookSearchRequestModel(query: keyword)
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey().X_Naver_Client_Id,
            "X-Naver-Client-Secret": APIKey().X_Naver_Client_Secret
        ]
        
        AF
            .request(url, method: .get, parameters: prameters, headers: headers)
            .responseDecodable(of: BookSearchResponseModel.self){response in
                switch response.result{
                case .success(let result):
                    completionHandler(result.items)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .resume()
    }
}
