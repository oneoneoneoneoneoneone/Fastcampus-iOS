import UIKit
import Foundation
import RxSwift


//Observable : subscribe로 구독(방출) 해야만 결과가 나옴

//observer EVENT
//next, completed, error

print("-----just-----")
//int 형식의 element 방출
//just - 1개의 element 방출
//subscribe - 방출, 구독
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("-----of-----")
//of - n개의 element 방출
Observable<Int>.of(1,2,3)
    .subscribe(onNext: {
        print($0)
    })

print("-----of-----")
//형식지정 없이 array로 방출 가능
Observable.of([1,2,3])
    .subscribe(onNext: {
        print($0)
    })

print("-----from-----")
//array만 취하여 순차적으로 방출함
Observable.from([1,2,3])
    .subscribe(onNext: {
        print($0)
    })


print("-----from+subscribe2-----")
//subscribe onNext 없이 방출 시, next 이벤트, completed 이벤트가 같이 출력 됨
Observable.from([1,2,3])
    .subscribe({
        print($0)
    })
print("-----of+subscribe2-----")
Observable.of(1,2,3)
    .subscribe({
        print($0)
    })

print("-----from+subscribe+element-----")
//
Observable.from([1,2,3])
    .subscribe({
        if let element = $0.element {
        print(element)
        }
    })
print("-----of+subscribe+element-----")
Observable.of(1,2,3)
    .subscribe({
        if let element = $0.element {
        print(element)
        }
    })


print("-----empty-----")
//empty - 아무것도 출력되지 않음. 즉시종료가 필요한 경우
Observable.empty()
    .subscribe{
        print($0)
    }

print("-----empty+Void-----")
//empty Void - completed 출력 됨 (타입추론이 불가하여 Void)
Observable<Void>.empty()
    .subscribe{
        print($0)
    }
print("-----empty+onCompleted-----")
Observable.empty()
    .subscribe(onNext: {
    },
    onCompleted: {
        print("completed")
    })


print("-----naver-----")
//naver 찐 아무것도 출력되지 않음 - debug 연산자로 실행 여부 확인 가능
Observable<Void>.never()
    .debug("never")
    .subscribe(onNext:{
        print($0)
    },
    onCompleted:{
        print("completed")
    })

print("-----range-----")
//range - 반복문..
Observable.range(start: 1, count: 9)
    .subscribe(onNext:{
        print($0)
    })


print("-----dispose-----")
//dispose - subscribe 뒤에 메모리 누수 방지로 작성
Observable.of(1,2,3)
    .subscribe(onNext:{
        print($0)
    })
    .dispose()

print("-----disposeBag-----")
//disposeBag - disposable은 disposeBag이 할당해제 할 때마다 dispose 호출. 생명주기
let disposeBag = DisposeBag()
Observable.of(1,2,3)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----create-----")
//create - 이벤트(next, completed, error)를 내뱉는 옵저버 속성을 이용해 Observable 시퀀스에 값을 쉽게 추가할 수 있음
//observer - any옵저버(제네릭타입), Disposable 리턴
Observable.create{ observer -> Disposable in
    observer.onNext(1)
    observer.onCompleted()
    observer.onNext(2)
    
    return Disposables.create()
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

print("-----create+onError-----")
//next > error > disposed
//next > completed > disposed
enum MyError: Error{
    case anError
}
Observable.create{ observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)


print("-----deffered1-----")
//subscribe를 기다리는 Observable을 만들지 않고, 각 subscribe에게 새롭게 Observable 항목을 제공
//Observable 팩토리 - Observable을 감싸는 Observable 형태
Observable.deferred{
    Observable.of(1,2,3)
}
.subscribe{
    print($0)
}
.disposed(by: disposeBag)

print("-----deffered2-----")
let factory: Observable = Observable.deferred{
    return Observable.of(1,2,3)
    
}

for _ in 0...2{
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}

