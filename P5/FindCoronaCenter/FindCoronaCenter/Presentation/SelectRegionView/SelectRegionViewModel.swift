//
//  SelectRegionViewModel.swift
//  FindCoronaCenter
//
//  Created by hana on 2023/04/10.
//

import Foundation
import Combine

//ObservableObject - 외부에서 바라볼 수 있는 오브젝트 , 뷰랑 연결할 때 사용
class SelectRegionViewModel: ObservableObject{
    //@Published - 내보낼 객체
    @Published var centers = [Center.Sido: [Center]]()
    private var cancellables = Set<AnyCancellable>()
    
    init(centerNetwork: CenterNetwork = CenterNetwork()){
        
        //receive - 뷰모델은 뷰에 쀼려져야해서 스트림을 메인스레드에 리시브함
        //sink - servescript
        //receiveCompletion - 실패했을 때 처리
        centerNetwork.getCenterList()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {[weak self] in
                    guard case .failure(let error) = $0 else {return}
                    print(error.localizedDescription)
                    self?.centers = [Center.Sido: [Center]]()
                },
                receiveValue: {[weak self] centers in
                    self?.centers = Dictionary(grouping: centers){ $0.sido} //[Center.Sido: [Center]] 형태의 sido를 키로하는 딕셔너리
                }
           )
            .store(in: &cancellables)
    }
    
}
