import RxSwift
import RxCocoa
import UIKit
//ui화면을 볼 수 있음
import PlaygroundSupport


let disposeBag = DisposeBag()

enum TraitsError: Error{
    case single
    case maybe
    case completable
}


print("-----replay-----")
//replay(Int) - connect() 필수. 지나간 onNext 값을 버퍼(인수) 크기만큼 저장함. 서브스크리브 이후 onNext는 버퍼 크기와 상관 없이 방출
let 인삿말 = PublishSubject<String>()
let 앵무새 = 인삿말.replay(3)
앵무새.connect()

인삿말.onNext("안녕")
인삿말.onNext("봉쥬르")

앵무새
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

인삿말.onNext("하이")

print("-----replayAll-----")
//replayAll() - connect() 필수. 지나간 onNext 값을 갯수 제한 없이 저장함
let 인삿말2 = PublishSubject<String>()
let 앵무새2 = 인삿말2.replayAll()
앵무새2.connect()

인삿말2.onNext("안녕")
인삿말2.onNext("봉쥬르")
인삿말2.onNext("봉쥬르")
인삿말2.onNext("봉쥬르")
인삿말2.onNext("봉쥬르")
인삿말2.onNext("봉쥬르")

앵무새2
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

인삿말2.onNext("하이")


print("-----buffer-----")
//schedule() - DispatchSourceTimer 특정시간마다 함수를 반복하는 메소드. 셋팅 후 resume() 필수
//buffer{} - 실행주기, 한번에 방출할 수 있는 최대갯수, 실행 스케줄러 타입 셋팅. 버퍼 실행 이후 onNext만 방출됨
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()                    //특정 시간마다 함수를 작동
//
//timer.schedule(deadline: .now() + 0, repeating: .seconds(1))    //2초 이전에는 실행됨, 1초마다 반복
//timer.setEventHandler{                                          //timer 설정에 따라 이벤트가 반복 됨
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume()
//
//
//source
//    .buffer(
//        timeSpan: .seconds(2),                                  //실행주기
//        count: 2,                                               //한번에 방출할 수 있는 최대 갯수
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext:{
//        print($0)
//    })
//    .disposed(by: disposeBag)

//source.onNext("1")
//source.onNext("2")
//source.onNext("3")
//source.onNext("4")
//source.onNext("5")


print("-----window-----")
//window() - 버퍼는 어레이 방출, 윈도우는 옵저버블 방출
//let MAX_Observable = 2
//let time = RxTimeInterval.seconds(1)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimerSource = DispatchSource.makeTimerSource()
//windowTimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimerSource.setEventHandler{
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimerSource.resume()
//
//window
//    .window(
//        timeSpan: time,
//        count: MAX_Observable,
//        scheduler: MainScheduler.instance
//    )
////    .subscribe(onNext: {
////        print($0)
////    })
//    .flatMap{windowObservable -> Observable<(index: Int, element: String)> in
//        return windowObservable.enumerated()
//    }
//    .subscribe(onNext: {
//        print("\($0.index)번째 옵저버블 요소 \($0.element)")
//    })
//    .disposed(by: disposeBag)


print("-----delaySubscription-----")
//delaySubscription() - 시간을 쉬프팅. subscribe만 지연시키는
//let delaySubject = PublishSubject<String>()

//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimeSource.setEventHandler{
//    delayCount += 1
//    delaySubject.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySubject
//    .delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
//    .subscribe(onNext:{
//        print($0)
//    })
//    .disposed(by: disposeBag)

//delaySubject.onNext("1")
//delaySubject.onNext("2")
//delaySubject.onNext("3")
//delaySubject.onNext("4")
//delaySubject.onNext("5")


print("-----delay-----")
//delay() - 전체 시퀀스를 뒤로 미룸. subscribe, onnext 다 미룸..??
//let delaySubject = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimeSource.setEventHandler{
//    delayCount += 1
//    delaySubject.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySubject
//    .delay(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext:{
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//delaySubject.onNext("1")
//delaySubject.onNext("2")
//delaySubject.onNext("3")
//delaySubject.onNext("4")
//delaySubject.onNext("5")


print("-----interval-----")
//interval() - 타이머 관련 오퍼레이터. 임의로 만든 타이머를 바로 구현. 생성자 없이 타입추론으로 엘러멘트 방출. 직관적
Observable<Int>
    .interval(.seconds(2), scheduler: MainScheduler.instance)
    .subscribe(onNext:{
        print($0)
    })
    .disposed(by: disposeBag)

print("-----timer-----")
//timer() - dueTime - 구독 이후, 첫째값 사이의 타임 = 지연시간..
//Observable<Int>
//    .timer(.seconds(2), period: .seconds(1), scheduler: MainScheduler.instance)
//    .subscribe(onNext:{
//        print($0)
//    })
//    .disposed(by: disposeBag)

print("-----timeout-----")
//timeout() - 정해진 시간이 초과되면(새로운 이벤트가 발생하지 않으면) 자동으로 에러발생.
let push = UIButton(type: .system)
push.setTitle("눌러주세요", for: .normal)
push.sizeToFit()

PlaygroundPage.current.liveView = push      //PlaygroundSupport

push.rx.tap                                 //RxCocoa
    .do(onNext: {                           //do - 옵저버블 스트림에 영향을 주지 않고, 실행되는 이벤트를 볼 수 있음
        print("tap")
    })
    .timeout(.seconds(5),
             scheduler: MainScheduler.instance)
    .subscribe(){
        print($0)
    }
    .disposed(by: disposeBag)
