//
//  CenterDetailView.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import SwiftUI

struct CenterDetailView: View {
    var center: Center
    
    var body: some View {
        VStack{
            MapView(coordination: center.coordinate)
                .ignoresSafeArea(edges: .all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            CenterRow(center: center)
        }
        .navigationTitle(center.facilityName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CenterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, address: "경기도 어쩌고", lat: "37.123456", lng: "126.1234678", centerName: "시민체육관", centerType: .central, facilityName: "정문 앞", phoneNumber: "010-1234-6789")
        
        CenterDetailView(center: center0)
    }
}
