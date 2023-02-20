//
//  PageViewContoller.swift
//  MyAssets
//
//  Created by hana on 2022/07/07.
//

import SwiftUI
import UIKit

//Representable - UIKit의 Class(PageViewContoller)를 SwiftUI 계층구조로 통합하기 위한 wrapper Class
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int   //현재 어떤 페이지가 보여지고 있는지 상태 확인
    
    ////프로토콜 준수사항..
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        return pageViewController
    }
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]],
            direction: .forward,
            animated: true
        )
    }
    
    //UIKet 특성인 delegate, datasource를 받을 수 있도록 별도 조정자(Coordinator)를 추가
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
        var parent: PageViewController
        var controllers = [UIViewController]()
        
        init(_ pageViewController: PageViewController){  //먼소리고;;
            parent = pageViewController
            controllers = parent.pages.map{UIHostingController(rootView: $0)}
        }
        
        //viewControllerBefore
        //페이지뷰스크롤러가 방향상관없이 자연스럽게 배너처럼 움직이는 함수
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {return nil}
            if index == 0{
                return controllers.last
            }
            
            return controllers[index - 1]
        }
        
        //viewControllerAfter
        //마지막 페이지가 나오면 처음으로 돌아감
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {return nil}
            if index + 1 == controllers.count{
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        //didFinishAnimating
        //뷰컨트롤러가 페이지뷰컨트롤러의 첫번째일 때, 애니메이션이 끝났을 때 Binding currentPage와 연결
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController){
                parent.currentPage = index
            }
        }
    }
    
}
