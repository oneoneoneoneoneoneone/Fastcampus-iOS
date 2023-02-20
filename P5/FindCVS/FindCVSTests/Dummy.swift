//
//  Dummy.swift
//  FindCVSTests
//
//  Created by hana on 2023/02/08.
//

import Foundation

@testable import FindCVS

var cvsList: [KLDocument] = Dummy().load("networkDummy.json")

class Dummy{
    func load<T: Decodable>(_ filename: String) -> T{       //전역변수 더미데이터를 받아 디코딩
        let data: Data
        let bundle = Bundle(for: type(of: self))
        
        guard let file = bundle.url(forResource: filename, withExtension: nil) else{
            fatalError("불러올 수 없음 - \(error)")
        }
        
        do{
            data = try Data(contentsOf: file)
        }
        catch{
            fatalError("불러올 수 없음 - \(error)")
        }
        
        do{
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        catch{
            fatalError("파싱할 수 없음 - \(error)")
        }
        
    }
}
