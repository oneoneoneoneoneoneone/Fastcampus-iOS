//
//  AssetSectionView.swift
//  MyAssetsApp
//
//  Created by hana on 2022/07/08.
//

import SwiftUI

struct AssetSectionView: View {
    //관찰할 수 있는 오브젝트(Asset) - ObservedObject 관찰하는 오브젝트(assetSection)
    @ObservedObject var assetSection: Asset
    var body: some View {
        VStack(spacing: 20){
            AssetSectionHeaderView(title: assetSection.type.title)
            ForEach(assetSection.data){ asset in
                HStack{
                    Text(asset.title)
                        .font(.title)
                        .foregroundColor(.secondary)
                        Spacer()
                    Text(asset.amount)
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Divider()
            }
        }
        .padding()
    }
}

struct AssetSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = Asset(
        id: 0,
        type: .bankAccount,
        data:[
            AssetData(id: 0, title: "신한은행", amount: "5,000,000원"),
            AssetData(id: 0, title: "신한은행", amount: "5,000,000원")
        ]
        )
        AssetSectionView(assetSection: asset)
    }
}
