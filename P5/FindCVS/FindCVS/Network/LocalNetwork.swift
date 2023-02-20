//
//  LocalNetwork.swift
//  FindCVS
//
//  Created by hana on 2022/09/29.
//

import RxSwift

class LocalNetwork{
    private let session: URLSession
    let api = LocalAPI()
    
    init(session: URLSession = .shared){
        self.session = session
    }
    
    //네트워크는 성공 or 실패 결과만 나오는 Result
    //Result 타입은 .success, .failure 두개의 값을 각각 리턴해야만 함
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        guard let url = api.getLocation(by: mapPoint).url else {
            return .just(.failure(URLError(.badURL)))       //.just는 Result<LocationData, URLError>(일반 element)의 1개의 element 방출!!
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK bc026d18680e1f7ab97677eb5a505ba2", forHTTPHeaderField: "Authorization")       //forHTTPHeaderField - header / forKey - body
        
        return session.rx.data(request: request as URLRequest)
            .map{data in
                do{
                    let locationData = try JSONDecoder().decode(LocationData.self, from: data)
                    return .success(locationData)
                }catch{
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch{_ in .just(Result.failure(URLError(.cannotLoadFromNetwork)))}
            .asSingle()
                    
    }
}
