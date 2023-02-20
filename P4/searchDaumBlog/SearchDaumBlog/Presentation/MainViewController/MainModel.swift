//
//  MainModel.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/22.
//

import RxSwift
import UIKit

struct MainModel{
    let network = SearchBlogNetwork()
    
    ///shouldLoadResult 이게 머야. 검색바 텍스트를 가져와서 쿼리 넣어서 네트워크 태움
    func searchBlog(_ query: String) -> Single<Result<DKBlog, SearchNetworkError>>{
        return network.searchBlog(query: query)
    }
    
    ///네트워크 응답으로 받은 Result의 value만 추출해서 반환
    func getBlogValue(_ result: Result<DKBlog, SearchNetworkError>) -> DKBlog?{
        guard case .success(let value) = result else{
            return nil
        }
        return value
    }
    
    ///네트워크 응답으로 받은 Result의 error만 추출해서 반환
    func getBlogError(_ result: Result<DKBlog, SearchNetworkError>) -> String?{
        guard case .failure(let error) = result else{
            return nil
        }
        return error.localizedDescription
    }
    
    ///성공한 응답값을 cellData 형식에 맞게 맵핑 (string -> url(BlogListCellData... 형식에 맞게))
    func getBlogListCellData(_ value: DKBlog) -> [BlogListCellData]{
        return value.documents
            .map{doc in
                let thumbnailURL = URL(string: doc.thumbnail ?? "")
                return BlogListCellData(
                    thumbnailURL: thumbnailURL,
                    name: doc.name,
                    title: doc.title,
                    datetime: doc.datetime
                )
            }
    }
    
    ///사용자 데이터를 받아서 선택한 얼랏액션에 맞게 정렬
    func sort(by type: MainViewController.AlertAction, of data: [BlogListCellData]) -> [BlogListCellData] {
        print("MainModel - sort")
        switch type{
        case .title:
            return data.sorted {$0.title ?? "" < $1.title ?? ""}
        case .datetime:
            return data.sorted {$0.datetime ?? Date() > $1.datetime ?? Date()}
        default:
            return data
        }
    }
}
