import RxSwift

let disposeBag = DisposeBag()

print("-----startWith-----")
//startWith - 초기값을 받음. 제일 먼저 출력 됨 ex 네트워크 현재상태..
let class1 = Observable<String>.of("a", "b", "c")

class1
    .enumerated()
    .map{index, element in
        return element + "어린이" + "\(index)"
    }
    .startWith("teacher2")   //Observable 타입과 같아야함
    .startWith("teacher1")
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----concat1-----")
//concat - 콜렉션, 시퀀스 간 조합
let class2 = Observable<String>.of("a", "b", "c")
let teacher = Observable<String>.of("teacher")

let printing = Observable<String>
    .concat([teacher, class2, class1])  //선언 할 때는 콜렉션 or 시퀀스

printing
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("-----concat2-----")
teacher
    .concat(class2)     //기존 옵저버블에 추가할 때는 시퀀스
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----concatMap-----")
//flatMap - 옵저버블 시퀀스가 구독을 위해 리턴되고, 방출 된 옵저버블이 합쳐짐
//concatMap - 각 시퀀스가 다음 시퀀스가 구독 되기 전에 합쳐짐
let classes: [String: Observable<String>] = [
    "a반": Observable.of("a", "b", "c"),
    "b반": Observable.of("A", "B", "C")
]

Observable.of("a반", "b반", "c반")
    .concatMap{c in
               classes[c] ?? Observable.of("empty")//.empty()
    }
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----merge1-----")
//merge - 시퀀스를 합치는데 순서에 규칙성이 없음. 시퀀스에 에러가 있으면 머지 도중 종료 됨
let location1 = Observable.from(["서울", "인천", "광주", "성남", "하남"])
let location2 = Observable.from(["전주", "익산", "군산", "남원"])

Observable.of(location1, location2)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----merge2-----")
//mergeMaxConcurrent - 한번에 받아낼 옵저버블의 수. 첫번째 구독하는 옵저버블이 element를 뱉기 전까지 다른 옵저버블을 받지 않음.
//네트워크 연결이 많을때 리소스를 제한하는 경우
Observable.of(location1, location2)
    .merge(maxConcurrent: 1)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----combinLatest1-----")
//combinLatest - 값을 방출할 때마다 해당 클로저를 호출하여 인라인 안에 결합규칙을 적용하여 방출함. 시퀀스에 모두 값이 있어야 호출됨.
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름){성, 이름 in
        성 + 이름
    }

성명
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

성.onNext("김")
이름.onNext("하나")
이름.onNext("둘")
이름.onNext("셋")
성.onNext("이")
이름.onNext("넷")
성.onNext("박")

print("-----combinLatest2-----")
//8개까지
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .medium, .long, .full, .none)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: {형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        })

현재날짜표시
    .subscribe(onNext:{
    print($0)
})
.disposed(by: disposeBag)

print("-----combinLatest3-----")
//joined - 시퀀스 형식의 배열을 결합하는 메소드
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]){name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("박")
firstName.onNext("하나")
firstName.onNext("둘")
firstName.onNext("셋")


print("-----zip-----")
//zip - merge, combinlatest 와 다른 점은 결합되는 하나의 옵저버블이 완료되면 전체 완료 됨
enum 성씨 {
    case 박
    case 김
    case 이
}
let 성1 = BehaviorSubject<성씨>(value: .박)
let 이름1 = BehaviorSubject<String>(value: "하나")

let 성명1 = Observable
    .zip(성1, 이름1){성, 이름 in
        return "\(성) \(이름)"
    }

성명1
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

성1.onNext(.김)
성1.onNext(.김)
이름1.onNext("둘")
이름1.onNext("셋")
이름1.onNext("넷")
이름1.onNext("다섯")
성1.onNext(.박)


print("-----withLatestFrom-----")
//withLatestFrom - 둘중 한개의 옵저버블의 onNext가 트리거가 되어 두번째 옵저버블의 최신값을 방출
//distinctUntileChanged() 연산자를 사용하면 동일한 이벤트를 걸러줌
let 제출 = PublishSubject<Void>()
let 과제 = PublishSubject<String>()

제출
    .withLatestFrom(과제)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

과제.onNext("최종")
과제.onNext("최최종")
과제.onNext("진짜최종")
제출.onNext(Void())
제출.onNext(Void())


print("-----sample-----")
//sample - withLatestFrom와 다른점은 트리거가되는 옵저버블을 여러번 onNext해도 한번만 방출
제출
    .sample(과제)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

과제.onNext("최종")
과제.onNext("최최종")
과제.onNext("진짜최종")
제출.onNext(Void())


print("-----amb-----")
//amb - 모호한. 두가지 옵저버블을 모두 구독하지만, 먼저 onNext하는 옵저버블에 대해서만 구독함. 세컨옵저버블이 따로 없음.
let a = PublishSubject<String>()
let b = PublishSubject<String>()

let result = a.amb(b)

result
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

a.onNext("a: ↑")
a.onNext("a: ↑")
b.onNext("b: ↓")
b.onNext("b: ↑")
a.onNext("a: ↓")
b.onNext("b: ↓")
a.onNext("a: ↓")
a.onNext("a: ↑")


print("-----switchLatest-----")
//switchLatest - 소스.옵저버블이 마지막으로 구독한 시퀀스의 구독 이후 onNext만 방출
let a1 = PublishSubject<String>()
let b1 = PublishSubject<String>()
let switchOn = PublishSubject<Observable<String>>()

let result2 = switchOn.switchLatest()

result2
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

switchOn.onNext(a1)
a1.onNext("a: 1")
b1.onNext("b: 1")

switchOn.onNext(a1)
b1.onNext("b: 2")
a1.onNext("a: 2")

switchOn.onNext(b1)
a1.onNext("a: 3")
b1.onNext("b: 3")

switchOn.onNext(a1)
b1.onNext("b: 4")
a1.onNext("a: 4")


print("-----reduce-----")
//reduce - 시퀀스 내 요소를 결합. 최종 값 방출. 누산기...
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newV in
//            return summary + newV
//    })
//    .reduce(0){summary, newV in
//        return summary + newV
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)


print("-----scan-----")
//scan - reduce와 다른점은 새로운 값이 들어올 때마다 바뀐 값을 방출
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)
