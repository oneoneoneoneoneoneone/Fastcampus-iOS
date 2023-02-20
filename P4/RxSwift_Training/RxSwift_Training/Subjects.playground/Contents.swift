import UIKit
import Foundation
import RxSwift


let disposeBag = DisposeBag()

enum SubjectError: Error{
    case error1
}

print("-----publishSubject-----")
let publishSubject = PublishSubject<String>()   //초기값 없음

publishSubject.onNext("1")

let subscriber1 = publishSubject
    .subscribe(onNext: {
        print("첫번째 구독자 : \($0)")
    })

publishSubject.onNext("2")

publishSubject.on(.next("3"))

subscriber1.dispose()

let subscriber2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독자 : \($0)")
    })

publishSubject.onNext("4")
publishSubject.onCompleted()                    //Completed 이 후 Next, subscribe는 실행되지 않음

publishSubject.onCompleted()
publishSubject.onNext("5")

subscriber2.dispose()

publishSubject.subscribe({
        print("세번째 구독자 : ", $0.element ?? $0)
    })
    .disposed(by: disposeBag)

publishSubject.onNext("6")


print("-----behaviorSubject-----")
let behaviorSubject = BehaviorSubject<String>(value: "0")

behaviorSubject.onNext("1")

behaviorSubject.subscribe{
    print("첫번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.onNext("1")
behaviorSubject.subscribe{
    print("두번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

behaviorSubject.onNext("2")

//Observable - onnext 클로저 안에서만 value를 확인할 수 있음
//behaviorSubject - try 구문으로 .value()로 확인 가능 (사용은 잘 안함)
let value = try? behaviorSubject.value()
print(value)


print("-----ReplaySubject-----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)     //size = 저장할 수 있는 subscribe 직전 onNext 수 (error는 저장하지 않음)

replaySubject.onNext("1")
replaySubject.onNext("2")
replaySubject.onNext("3")

replaySubject.subscribe{
    print("첫번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe{
    print("두번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()                             //dispose 이후 subscribe하면 에러남

replaySubject.subscribe{
    print("세번째 구독 : ", $0.element ?? $0)
}
.disposed(by: disposeBag)
