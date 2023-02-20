//
//  ContentView.swift
//  NetflixStyleSampleApp
//
//  Created by hana on 2022/06/27.
//

import SwiftUI

struct ContentView: View {
    let titles = ["Netflix Sample App"]
    var body: some View {
        NavigationView{
            List(titles, id: \.self){
                //SwiftUI > NavigationView > List > HomeViewController(넷플릭스 화면)
                let netflixVC = HomeViewControllerRepresentable()
                    .navigationBarHidden(true)
                    .edgesIgnoringSafeArea(.all)
                NavigationLink($0, destination: netflixVC)
            }
            .navigationTitle("SwiftUI to UIKit")
                
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
