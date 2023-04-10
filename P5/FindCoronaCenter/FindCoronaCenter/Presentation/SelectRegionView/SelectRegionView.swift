//
//  SelectRegionView.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import SwiftUI

struct SelectRegionView: View {
    @ObservedObject var viewModel = SelectRegionViewModel()
    
    private var items: [GridItem]{
        Array(repeating: .init(.flexible(minimum: 80)), count: 2)
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: items, spacing: 20){
                    ForEach(Center.Sido.allCases, id: \.id){ sido in
                        let centers = viewModel.centers[sido] ?? []
                        //화면이동
                        //destination - 전달 데이터
                        //탭했을 때
                        NavigationLink(
                            destination: CenterList(centers: centers)){
                            SelectRegionItem(region: sido, count: centers.count)
                        }
                    }
                }
                .padding()
                .navigationTitle("코로나19 예방접종 센터")
            }
        }
    }
}

struct SelectRegionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SelectRegionViewModel()
        SelectRegionView(viewModel: viewModel)
    }
}
