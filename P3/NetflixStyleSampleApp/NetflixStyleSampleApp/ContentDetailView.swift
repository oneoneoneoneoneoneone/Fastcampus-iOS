//
//  ContentDetailView.swift
//  NetflixStyleSampleApp
//
//  Created by hana on 2022/07/05.
//

import SwiftUI

struct ContentDetailView: View {
    //외부 작용 없이 내부 상태 변화 설정
    @State var item: Item?
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            ZStack(alignment: .bottom) {
                if let item = item{
                    Image(uiImage: item.image)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                    
                    Text(item.description)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.primary)
                        .background(Color.primary.colorInvert().opacity(0.75))
                }else{
                    Color.white
                }
            }
        }
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let item0 = Item(description: "흥미진진, 판타지 . . .", imageName: "poster0")
        ContentDetailView(item: item0)
    }
}
