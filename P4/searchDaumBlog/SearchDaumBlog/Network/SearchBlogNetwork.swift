//
//  SearchBlogNetwork.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/18.
//

import RxSwift
import Foundation

enum SearchNetworkError: Error{
    case invalidURL
    case invalidJSON
    case networkError
}

class SearchBlogNetwork{
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    //성공 or 실패 결과만 확인하기때문에 Single<>
    //enum 타입의 Result<Success, Failure>
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>>{
        guard let url = api.searchBlog(query: query).url else{
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        //header
        request.setValue("KakaoAK dfcbfb27a3ce57dd10b18a3dea1822e6", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map{data in
                //json encoding
                do{
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                }catch{
                    return .failure(.invalidJSON)
                }
            }
            .catch{_ in
                    .just(.failure(.networkError))
            }
            //옵저버블 > single
            .asSingle()
        
    }
}
