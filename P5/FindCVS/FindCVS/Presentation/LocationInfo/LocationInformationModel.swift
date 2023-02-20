//
//  LocationInformationModel.swift
//  FindCVS
//
//  Created by hana on 2022/09/29.
//

import Foundation
import RxSwift

struct LocationInformationModel{
    let localNetwork: LocalNetwork
    
    init(localNetwork: LocalNetwork = LocalNetwork()){
        self.localNetwork = localNetwork
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>>{
        return localNetwork.getLocation(by: mapPoint)
    }
    
    func documentsToCellData(_ data: [KLDocument]) -> [DetailListCellData]{
        return data.map{
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = documentToMTMapPoint($0)
            
            return DetailListCellData(placeName: $0.placeName, addressName: address, distance: $0.distance, point: point)
        }
    }
    
    func documentToMTMapPoint(_ doc: KLDocument) -> MTMapPoint {
        let longitude = Double(doc.x) ?? .zero
        let latitude = Double(doc.y) ?? .zero
        
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
}
