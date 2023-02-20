import RxSwift


let disposeBag = DisposeBag()

print("-----toArray-----")
//toArray - observable개체를 Single<string> 배열로 형변환 함
Observable.of("A","B","C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)


print("-----map-----")
//map - 지정된 데이터타입 형식으로 인라인에서 설정
Observable.of(Date())
    .map{date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("-----flatMap-----")
//flatMap - 옵저버블이 중첩되는 형식일 때, 상위 값에 접근할 수 있음
protocol player {
    var score: BehaviorSubject<Int> {get}
}

struct archeryPlayer: player{
    var score: BehaviorSubject<Int>
}

let korea = archeryPlayer(score: BehaviorSubject<Int>(value:10))
let usa = archeryPlayer(score: BehaviorSubject<Int>(value:9))

let Test = PublishSubject<player>()

Test.flatMap{player in
        player.score
    }
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

Test.onNext(korea)
Test.onNext(usa)
korea.score.onNext(0)
usa.score.onNext(1)
Test.onNext(usa)
Test.onNext(korea)


print("-----flatMapLatest-----")
//flatMapLatest - 가장 최신 값만 확인. 최근에 참조한 시퀀스의 값만 출력하고 이전 시퀀스는 해지함 (map + switchLatest)
//switchLatest - 가장최근 옵저버블에서 값을 생성하고, 이전 옵저버블은 구독 해지함
//네트워킹 조작에 사용됨. 사전, 빠른 검색어를 보여줄 때 사용 됨

let japan = archeryPlayer(score: BehaviorSubject<Int>(value:10))
let china = archeryPlayer(score: BehaviorSubject<Int>(value:9))

let Test2 = PublishSubject<player>()

Test2.flatMapLatest{player in
        player.score
    }
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

Test2.onNext(japan)
Test2.onNext(china)    //같은 단계의 서브젝트인 시퀀스를 구독하면, 이전에 구독한 시퀀스는 해지됨. onNext해도 방출되지 않음
japan.score.onNext(1)
china.score.onNext(11)
china.score.onNext(12)
japan.score.onNext(2)
japan.score.onNext(3)
print("----------")
Test2.onNext(china)
Test2.onNext(japan)
japan.score.onNext(1)
china.score.onNext(11)
china.score.onNext(12)
japan.score.onNext(2)
japan.score.onNext(3)


print("-----meteriallize and demeterialize-----")
//옵저버블을 이벤트로 변환. 옵저버블 속성을 가진 옵저버블 항목을 제어할 수 없고, 외부적으로 옵저버블이 종료되는 것을 방지하기위한 에러이벤트 처리
enum foul: Error {
    case bb
}

let hana = archeryPlayer(score: BehaviorSubject<Int>(value:0))
let haha = archeryPlayer(score: BehaviorSubject<Int>(value:1))

let Test3 = BehaviorSubject<player>(value: hana)

Test3.flatMapLatest{player in
        player.score
        .materialize()          //이벤트를 포함하여 next(value) 형태로 출력
    }
    .filter{                    //materialize 메소드에 사용할 수 있음
    guard let error = $0.error else {
        return true
    }
    print(error)
    return false
    }
    .dematerialize()            //이벤트를 제거하여 value만 출력
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
 
hana.score.onNext(1)
hana.score.onError(foul.bb)
hana.score.onNext(2)            //error 이후 값 출력 안딤..

Test3.onNext(haha)


print("-----!!-----")
