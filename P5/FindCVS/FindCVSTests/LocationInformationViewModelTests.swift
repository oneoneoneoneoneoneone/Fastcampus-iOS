//
//  LocationInformationViewModelTests.swift
//  FindCVSTests
//
//  Created by hana on 2023/02/08.
//

import XCTest
import Nimble
import RxSwift
import RxTest

@testable import FindCVS

final class LocationInformationViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    
    let stubNetwork = LocalNetworkStub()
    var model = LocationInformationModel!
    var viewModel: LocationInformationViewModel!
    var doc: [KLDocument]!
    
    override class func setUp() {
        self.model = LocationInformationModel(localNetwork: stubNetwork)
        self.viewModel = LocationInformationViewModel(model: model)
        self.doc = cvsList
    }


}
