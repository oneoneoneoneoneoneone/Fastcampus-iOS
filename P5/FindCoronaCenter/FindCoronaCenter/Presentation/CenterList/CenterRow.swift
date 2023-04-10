//
//  CenterRow.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import SwiftUI

struct CenterRow: View {
    var center: Center
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(center.facilityName)
                    .font(.headline)
                Text(center.centerType.rawValue)
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            Text(center.address)
                .font(.footnote)
            
            if let url = URL(string: "tel:" + center.phoneNumber){
                Link(center.phoneNumber, destination:  url)
            }
        }
        .padding()
    }
}

struct CenterRow_Previews: PreviewProvider {
    static var previews: some View {
        let center0 = Center(id: 0, sido: .경기도, address: "경기도 어쩌고", lat: "37.123456", lng: "126.1234678", centerName: "시민체육관", centerType: .central, facilityName: "정문 앞", phoneNumber: "010-1234-6789")
        CenterRow(center: center0)
    }
}
