import RxSwift
import Foundation


let disposeBag = DisposeBag()

enum TraitsError: Error{
    case single
    case maybe
    case completable
}


print("-----Single1-----")
Single<String>.just("🤩")
    .subscribe(
        onSuccess: {                //onNext + onCompleted
            print($0)
        },
        onFailure: {                //onError
            print("error: \($0)")
        },
        onDisposed: {               //disposed
            print("disposed")
        })

print("-----Single2-----")
Observable<String>
    .create{observer -> Disposable in
        observer.onError(TraitsError.single)
        return Disposables.create()
    }
    .asSingle()
    .subscribe(
        onSuccess: {                //onNext + onCompleted
            print($0)
        },
        onFailure: {                //onError
            print("error: \($0.localizedDescription)")
        },
        onDisposed: {               //disposed
            print("disposed")
        })
    .disposed(by: disposeBag)


print("-----Single3-----")
//네트워크 데이터를 주고받는 경우, 성공/실패 여부 확인
struct SomeJSON: Decodable{
    let name: String
}

enum JsonError: Error {
    case decodingError
}

let json1 = """
    {"name":"park"}
    """
let json2 = """
    {"my_name":"park"}
    """

func decode(json: String) -> Single<SomeJSON> {                                         //SomeJSON 타입 반환
    Single<SomeJSON>.create{ observer -> Disposable in
        guard let data = json.data(using: .utf8),
              let json = try? JSONDecoder().decode(SomeJSON.self, from: data) else {    //SomeJSON에 맞춰 decoding
            observer(.failure(JsonError.decodingError))                                 //데이터가 맞지 않으면 failure 이벤트에 error값 전달
            return Disposables.create()
        }
        
        observer(.success(json))                                                        //success 이벤트에 json을 전달
        return Disposables.create()
    }
}

decode(json: json1)
    .subscribe{
        switch $0{
        case .success(let json):
            print(json.name)
        case .failure(let error):
            print(error)
        }
    }
    .disposed(by: disposeBag)


print("-----Maybe1-----")
//아무런 이벤트를 내보내지 않는 complete 클로저
Maybe<String>.just("🤩")
    .subscribe(
        onSuccess: {                //onNext + onCompleted
            print($0)
        },
        onError: {                //
            print("error: \($0)")
        },
        onCompleted: {                //
            print("completed")
        },
        onDisposed: {               //disposed
            print("disposed")
        })
    .disposed(by: disposeBag)


print("-----Completable1-----")
//completed 
//as.. 없음. create로만 생성 가능
Completable.create{ observer -> Disposable in
    observer(.error(TraitsError.completable))
    return Disposables.create()
}
.subscribe(
    onCompleted:{
        print("completed")
    } ,
    onError: {
        print("error: \($0)")
    },
    onDisposed:{
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("-----Completable2-----")

Completable.create{ observer -> Disposable in
    observer(.completed)
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)
