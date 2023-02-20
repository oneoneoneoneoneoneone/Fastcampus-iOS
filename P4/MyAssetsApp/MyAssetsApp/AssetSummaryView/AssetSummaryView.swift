//
//  AssetSummaryView.swift
//  MyAssetsApp
//
//  Created by hana on 2022/07/08.
//

import SwiftUI

struct AssetSummaryView: View {
    //EnvironmentObject 외부에서 데이터를 받아 전체 상태를 변경
    //AssetSummaryData가 변경될 때마다 자동으로 reflash 함
    @EnvironmentObject var assetData: AssetSummaryData
    
    var assets: [Asset]{
        return assetData.assets
    }
    var body: some View {
        VStack(spacing: 20){
            ForEach(assets){asset in
                switch asset.type{
                case .creditCard:
                    AssetCardSectionView(asset: asset)
                        .frame(idealHeight: 250)
                default:
                    AssetSectionView(assetSection: asset)
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
    }
}

struct AssetSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        AssetSummaryView()
            .environmentObject(AssetSummaryData())
            .background(Color.gray.opacity(0.2))
        
    }
}
