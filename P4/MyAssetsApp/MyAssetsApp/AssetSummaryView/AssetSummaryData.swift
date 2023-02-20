//
//  AssetSummaryData.swift
//  MyAssetsApp
//
//  Created by hana on 2022/07/08.
//

import SwiftUI

///외부에서 별도 데이터 모델을 이용해서 데이터를 디코딩 후 뷰에 표시
class AssetSummaryData: ObservableObject {
    @Published var assets: [Asset] = load("assets.json")
}

func load<T: Decodable>(_ filename: String)-> T {
    let data: Data
    
    //파일 가져오기
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else{
        fatalError(filename + " XXX")
    }
    //파일 읽기
    do {
        data = try Data(contentsOf:  file)
    }catch{
        fatalError(filename + " XXX")
    }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }catch{
        fatalError(filename + " 파싱 XXX")
    }
}
