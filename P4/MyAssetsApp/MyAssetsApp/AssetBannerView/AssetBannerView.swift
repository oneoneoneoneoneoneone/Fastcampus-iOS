//
//  AssetBannerView.swift
//  MyAssets
//
//  Created by hana on 2022/07/07.
//

import SwiftUI

struct AssetBannerView: View {
    let bannerList: [AssetBanner] = [
        AssetBanner(title: "공지사항1", description: "추가된 공지사항을 확인하세요", backgroundColor: .red),
        AssetBanner(title: "공지사항2", description: "추가된 공지사항을 확인하세요", backgroundColor: .blue),
        AssetBanner(title: "공지사항3", description: "추가된 공지사항을 확인하세요", backgroundColor: .gray),
        AssetBanner(title: "공지사항4", description: "추가된 공지사항을 확인하세요", backgroundColor: .brown),
    ]
    @State private var currentPage = 0
    
    var body: some View {
        let bannerCards = bannerList.map{
            BannerCard(banner: $0)
        }
        
        ZStack(alignment: .bottomTrailing){
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberofPages: bannerList.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count * 18))
                .padding(.trailing)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(2.5, contentMode: .fit)
    }
}
