//
//  MTMapViewError.swift
//  FindCVS
//
//  Created by hana on 2022/09/28.
//

import Foundation

enum MTMapViewError: Error{
    case failedUpdatingCurrentLocation
    case locationAutorizationDenied
    
    var errorDescription: String{
        switch self{
        case .failedUpdatingCurrentLocation:
            return "현위치를 불러오지 못했습니다."
        case .locationAutorizationDenied:
            return "위치정보가 비활성화 되어있습니다."
        }
    }
}
