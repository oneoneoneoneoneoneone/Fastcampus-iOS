//
//  CenterAPI.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import Foundation


struct CenterAPI{
    static let scheme = "https"
    static let host = "api.odcloud.kr"
    static let path = "/api/15077586/v1/centers"
    
    func getCenterListComponents() -> URLComponents{
        var components = URLComponents()
        
        components.scheme = CenterAPI.scheme
        components.host = CenterAPI.host
        components.path = CenterAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "perPage", value: "300")
        ]
        
        return components
    }
}
