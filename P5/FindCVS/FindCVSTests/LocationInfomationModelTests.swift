//
//  LocationInfomationModelTests.swift
//  FindCVSTests
//
//  Created by hana on 2023/02/08.
//

import XCTest
import Nimble

@testable import FindCVS

final class LocationInfomationModelTests: XCTestCase {
    let stubNetwork = LocalNetworkStub()
    
    var doc: [KLDocument]!
    var model: LocationInformationModel!

    override func setUp() {
        self.model = LocationInformationModel(localNetwork: stubNetwork)
        self.doc = cvsList
    }

    func testDocumentsToCellData(){
        //documentsToCellData 메소드는 배열에서 배열로 값을 이동시킬 뿐, 값이 달라지거나 순서가 변경되어서는 안됨
        let cellData = model.documentsToCellData(doc)   //실제 모델의 값(DetailListCellData)
        let placeName = doc.map {$0.placeName}  //dummy 값(KLDocument)
        let address0 = cellData[1].address
        let roadAddressName = doc[1].roadAddressName
        
        expect(cellData.map{$0.placeName}).to(equal(placeName), description:"DetailListCellData.placeName은 KLDocument.placeName과 같음")
        
        expect(address0).to(equal(roadAddressName), description:"KLDocument.roadAddressName이 빈 값이 아닐경우, roadAddressName은 DetailListCellData.addressName에 전달 됨")
    }
}
