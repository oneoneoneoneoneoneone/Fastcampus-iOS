//
//  CenterList.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import SwiftUI

struct CenterList: View {
    var centers = [Center]()
    var body: some View {
        List(centers, id: \.id){center in
            NavigationLink(
                destination: CenterDetailView(center: center)){
                    CenterRow(center:center)
            }
            .navigationTitle(center.sido.rawValue)
        }
    }
}

struct CenterList_Previews: PreviewProvider {
    static var previews: some View {
        let centers = [Center(id: 0, sido: .경기도, address: "경기도 어쩌고", lat: "37.123456", lng: "126.1234678", centerName: "시민체육관", centerType: .central, facilityName: "정문 앞", phoneNumber: "010-1234-6789")]
        CenterList(centers: centers)
    }
}
