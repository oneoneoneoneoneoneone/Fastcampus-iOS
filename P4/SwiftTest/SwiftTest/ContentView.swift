//
//  ContentView.swift
//  SwiftTest
//
//  Created by hana on 2022/06/25.
//

import SwiftUI

struct ContentView: View {
    let helloFont: Font
    
    
    //init 생략, swift가 알아서 관리
    
    //View - body 필수
    var body: some View {
        MyView(helloFont: helloFont)
        VStack{ //StackView
            VStack{ //StackView
                Text("Hello, world!")
                    .font(.title)
                Text("Hello, world!")
                    .padding()
                    .font(helloFont)
            }
            VStack{ //StackView
                Text("Hello, world!")
                Text("Hello, world!")
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(helloFont: .title)
    }
}
