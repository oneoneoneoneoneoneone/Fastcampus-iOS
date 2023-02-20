//
//  AssetMenuGridView.swift
//  MyAssets
//
//  Created by hana on 2022/07/06.
//

import SwiftUI

struct AssetMenuGridView: View {
    let menuList: [[AssetMenu]] = [
        [.creditScore, .bankAccount, .investment, .loan],
        [.insurance, .creditCard, .cash, .realEstate]
    ]
    
    var body: some View{
        VStack(spacing: 20){
            ForEach(menuList, id: \.self){row in //menulist를 빼는데 id를 줌. 각행을 vstack에서 가져옴 (list)
                HStack(spacing: 10){
                    ForEach(row){ menu in
                        Button(""){
                            print("\(menu.title)버튼 tapped")
                        }
                        .buttonStyle(AssetMenuButtonStyle(menu: menu))
                    }
                }
            }
        }
    }
}

struct AssetMenuGridView_Previews: PreviewProvider {
    static var previews: some View {
        AssetMenuGridView()
    }
}
