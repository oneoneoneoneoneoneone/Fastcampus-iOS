//
//  DKBlog.swift
//  searchDaumBlog
//
//  Created by hana on 2022/09/18.
//

import Foundation

struct DKBlog: Decodable{
    let documents: [DKDocument]
}

struct DKDocument: Decodable{
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey{
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    //각 값이 매칭이 안될 것을 대비해 옵셔널처리???????
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try? values.decode(String?.self, forKey: .title)
        self.name = try? values.decode(String?.self, forKey:  .name)
        self.thumbnail = try? values.decode(String?.self, forKey: .thumbnail)
        self.datetime = Date.parse(values, key: .datetime)
    }
}


extension Date{
    //Date 타입 제이슨이 없어서 파싱하는 커스텀 함수 정의
    //CodingKey를 받아서 String을 Date 타입으로 파싱함
    static func parse<K: CodingKey>(_ values: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? values.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else {
            return nil
        }
        
        return date
    }
    
    static func from(dateString: String) -> Date?{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy=MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFormatter.date(from: dateString){
            return date
        }
        
        return nil
    }
}
