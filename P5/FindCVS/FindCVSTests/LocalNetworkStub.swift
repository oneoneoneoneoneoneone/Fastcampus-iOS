//
//  LocalNetworkStub.swift
//  FindCVSTests
//
//  Created by hana on 2023/02/08.
//

import Foundation
import RxSwift
import Stubber

@testable import FindCVS

class LocalNetworkStub: LocalNetwork{
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>>{
        return Stubber.invoke(getLocation, args: mapPoint)
    }
}
