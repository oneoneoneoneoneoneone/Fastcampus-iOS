//
//  NavigationBarWithButton.swift
//  MyAssets
//
//  Created by hana on 2022/07/06.
//

import SwiftUI

//ViewModifier 뷰에 버튼을 함수처럼 적용 가능
struct NavigationBarWithButton: ViewModifier {
    var title: String = ""
    
    func body(content: Content) -> some View {
        return content
            .navigationBarItems(
                leading: Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .padding(),
                trailing: Button(
                    action:{
                        print("자산추가버튼")
                    },
                    label: {
                        Image(systemName: "plus")
                        Text("자산추가")
                            .font(.system(size: 12))
                    }
                )
                .accentColor(.black)
                .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)  //모서리 둥글림
                    .stroke(Color.black)                //채움 없이 테두리만
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{          //navigationbar init함수에 추가하듯 UIKit 설정 가능
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = UIColor(white: 1, alpha: 0.5)
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance //줄어들었을 때
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

extension View{
    //SwiftUI에서 제공하는 모디파이 뒤에 적용 가능
    func navigationBarwithButtonStyle(_ title: String) -> some View {
        return self.modifier(NavigationBarWithButton(title: title))
    }
}

struct NavigationBarWithButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            Color.gray.edgesIgnoringSafeArea(.all)
                .navigationBarwithButtonStyle("내 자산")
        }
    }
}
