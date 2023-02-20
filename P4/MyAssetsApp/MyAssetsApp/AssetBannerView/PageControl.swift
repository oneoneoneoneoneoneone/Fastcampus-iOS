//
//  PageControl.swift
//  MyAssets
//
//  Created by hana on 2022/07/07.
//
//UIPageViewController 를 UIKit으로 구현 해볼 필요가 , , ,

import SwiftUI
import UIKit

//각 페이지 컨트롤 안에 들어갈 뷰
struct PageControl: UIViewRepresentable {
    var numberofPages: Int
    @Binding var currentPage: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberofPages
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateCurrentPage(sender:)),
            for: .valueChanged)

        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    class Coordinator: NSObject{
        var control: PageControl
        
        init(_ control: PageControl){
            self.control = control
        }
        
        @objc func updateCurrentPage(sender: UIPageControl){
            control.currentPage = sender.currentPage
        }
    }
}
