import RxSwift


let disposeBag = DisposeBag()

print("-----ignoreElements-----")
//ignoreElements - onNext는 무시
let sleepMode = PublishSubject<String>()

sleepMode.ignoreElements()
    .subscribe{
        print($0)
    }
    .disposed(by: disposeBag)

sleepMode.onNext("rrrr")
sleepMode.onNext("rrrr")
//sleepMode.onCompleted()


print("-----elementAt-----")
//elementAt - 해당 index의 값만 방출
let twoAlarm = PublishSubject<String>()

twoAlarm.element(at: 2)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

twoAlarm.onNext("r")
twoAlarm.onNext("rr")
twoAlarm.onNext("rrr")
twoAlarm.onNext("rrrr")


print("-----filter-----")
//filter - 필터 조건이 참인 인덱스만 방출
Observable.of(1,2,3,4,5,6,7,8,10,12)
    .filter{$0 % 2 == 0}
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("-----skip-----")
//skip - 해당 갯수만큼 스킵하고 이후 값부터 방출
Observable.of(1,2,3,4,5,6,7,8)
    .skip(5)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----skipWhile-----")
//skipWhile - 거짓이 나올 때까지 스킵하고 종료됨. false 값부터 방출
Observable.of(1,2,3,4,5,6,7,8)
    .skip(while: {
        $0 != 4
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----skipUntil-----")
//skipUntil - 다른 옵저버블이 onNext될 때까지 스킵됨.
let customer = PublishSubject<String>()
let open = PublishSubject<String>()

customer.skip(until: open)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

customer.onNext("손님1")
customer.onNext("손님2")
open.onNext("open")
customer.onNext("손님3")
customer.onNext("손님4")


print("-----take-----")
//take - 해당 갯수만큼만 방출
Observable.of(1,2,3,4,5,6,7,8)
    .take(5)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----takeWhile-----")
//takeWhile - 조건문이 참일 때까지만 출력하고 종료
Observable.of(1,2,3,4,5,6,7,8)
    .take(while:{
        $0 != 4
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----takeUntil-----")
//takeUntil - 다른 옵저버블이 onNext될 때까지만 방출
let customer2 = PublishSubject<String>()
let close = PublishSubject<String>()

customer2.take(until: close)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

customer2.onNext("손님1")
customer2.onNext("손님2")
close.onNext("close")
customer2.onNext("손님3")
customer2.onNext("손님4")


print("-----enumerated-----")
//enumerated - 방출된 요소의 인덱스를 포함한 튜플을 생성. (index, element)
Observable.of(1,2,3,4,5,6,7,8)
    .enumerated()
    .takeWhile({
        $0.index < 3
    })
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----distinctUntileChanged-----")
//distinctUntileChanged - 연달아 있는 값을 스킵하고 출력
Observable.of(1,1,1,2,2,2,3,3,3,1,1,2,2,10,10)
    .distinctUntilChanged()
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
