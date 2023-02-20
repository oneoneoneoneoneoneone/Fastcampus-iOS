//
//  MyView.swift
//  SwiftTest
//
//  Created by hana on 2022/06/25.
//

import SwiftUI

struct MyView: View {
    let helloFont: Font
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView(helloFont: .title)
    }
}
