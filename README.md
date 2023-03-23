# :pushpin: 패스트캠퍼스 iOS 온라인 강의 실습 프로젝트
처음 Swift 언어 학습을 위해 기초 문법부터 앱 제작까지 강의를 따라 실습한 프로젝트입니다.
>강의 정보: [[패스트캠퍼스]30개 프로젝트로 배우는 iOS 앱 개발 with Swift 초격차 패키지 Online](https://fastcampus.co.kr/dev_online_iosappfinal)</br>
>제작 기간: 2022.04 ~ 2023.02</br>
>참여 인원: 개인 프로젝트


</br>


## 학습 기술
- UIKit / SwiftUI
- RxSwift / RxCocoa
- SnapKit / Kingfisher
- Alamofire
- XCTest
- Firebase Cloud Messaging / Firebase Remote Config / Firebase A/B Testing
- Firebase Realtime Database / Firebase Authentication
- MVVM Achitecture / MVC Achitecture


</br>


## 주요 프로젝트

### 1. 실시간 공지사항 팝업 만들기
- 기능: 단순 공지사항 팝업을 띄우는 기능을 가진 앱으로, Firebase Remote Config와 연결하여 실시간으로 공지 내용을 변경할 수 있습니다.

- 프로젝트 코드: [🔗](https://github.com/oneoneoneoneoneoneone/Fastcampus-iOS/tree/main/P3/Notice)

- 화면
    |<img src="https://user-images.githubusercontent.com/94464179/220093765-63e010ac-3625-4aec-9911-4e0c2d7ed350.png" width="12%" height="12%" alt>| 
    |:--:|
    | *공지 화면* |
    
- 학습 내용
  - Firebase Remote Config

- 주요 기능을 구현한 코드
    <details>
    <summary>코드 흐름</summary>
    <div markdown="1">

    - Firebase Remote Config 연결
      ~~~swift
      //ViewController
        var remoteConfig: RemoteConfig?
        remoteConfig = RemoteConfig.remoteConfig()

        let setting = RemoteConfigSettings()
        //테스트를 위해 새로운 값을 패치하는 리커버를 최소화해서 최대한 자주 가져옴//개발 중 0
        setting.minimumFetchInterval = 0

        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
      ~~~

    - 공지확인 터치시 Firebase A-B Test 기록
      ~~~swift
      //ViewController
        let confirmAction = UIAlertAction(title: "확인하기", style: .default) { _ in
            //google analytics 이벤트 기록
            Analytics.logEvent("promotion_alert", parameters: nil)
        }
      ~~~

    </div>
    </details>


</br>


### 2. 재난문자 푸시 알림 구현하기
- 기능: Firebase Clouding Messaging 사용해 APNs 알림을 보낼 수 있습니다.

- 프로젝트 코드: [🔗](https://github.com/oneoneoneoneoneoneone/Fastcampus-iOS/tree/main/P3/Notice)

- 학습 내용
  - CocoaPads
  - Firebase Clouding Messaging
  - APNs

- 주요 기능을 구현한 코드
    <details>
    <summary>FCM 토큰 발급</summary>
    <div markdown="1">

    ~~~swift
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            guard let token = fcmToken else {return}
            print("FCM 등록토큰 갱신: \(token)")
        }
    ~~~

    </div>
    </details>


</br>


### 3. 물마시기 알람 앱 만들기
- 기능: 물마시기 알림을 추가하고 설정한 시간에 알림을 받아볼 수 있습니다. 

- 프로젝트 코드: [🔗](https://github.com/oneoneoneoneoneoneone/Fastcampus-iOS/tree/main/P3/Drink)

- 화면
    |<img src="https://user-images.githubusercontent.com/94464179/218811403-eeace868-3889-4fc7-a9d8-fbbce151f7b9.png" width="25%" height="25%" alt>|<img src="https://user-images.githubusercontent.com/94464179/218811403-eeace868-3889-4fc7-a9d8-fbbce151f7b9.png" width="25%" height="25%" alt>| 
    |:--:|:--:|
    | *리스트 화면* | *알림 추가 화면* |
    
- 학습 내용
  - UNUserNotificationCenter
    - UNAuthorizationOptions 사용자 승인
    - UNCalendarNotificationTrigger 특정날짜(시간) 알림
    - UNTimeIntervalNotificationTrigger 다시 알림
  - datePicker & DateFormmet

- 주요 기능을 구현한 코드
    <details>
    <summary>코드 흐름</summary>
    <div markdown="1">

    - 알림추가 화면에서 리스트뷰로 데이터 넘기기
      ~~~swift
      //AddAlertViewController

        var pickedDate: ((_ date: Date,_ isRepeat: Bool, _ duration: Double) -> Void)? 

        @IBAction func saveButtonTap(_ sender: UIBarButtonItem) {
            pickedDate?(datePicker.date, isRepeatSwitch.isOn, datePicker.date.timeIntervalSinceNow + timePicker.countDownDuration)

            self.dismiss(animated: true, completion: nil)
        }
      ~~~

    - 테이블뷰에서 추가된 알림을 UNUserNotificationCenter에 넘기기
      ~~~swift
      //AlertListViewController

        addAlertVC.pickedDate = {[weak self] date, isRepeat, duration in
            guard let self = self else {return}

            let newAlert = Alert(date: date, isOn: true, isRepeat: isRepeat, duration: duration)

            ... //테이블뷰 데이터 업데이트 및 정렬, 내부저장소 저장

            //센터에 알림을 추가하는 메소드 호출
            self.userNotificationCenter.addNotificationRequest(by: newAlert)
        }
      ~~~

    - UNUserNotificationCenter에 알림 추가
      ~~~swift
      //UNUserNotificationCenter

        let content = UNMutableNotificationContent()
        ... //content 설정

        //UNCalendarNotificationTrigger - 시간 알림
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        self.add(request, withCompletionHandler: nil)

        //UNTimeIntervalNotificationTrigger - 타이머 알림 (다시알림)
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: alert.duration, repeats: false)
        let timeRequest = UNNotificationRequest(identifier: alert.id, content: content, trigger: timeTrigger)
        self.add(timeRequest, withCompletionHandler: nil)
      ~~~

    - 사용자 알림 승인
      ~~~swift 
      //AppDelegate

        let authrizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotificationCenter.requestAuthorization(options: authrizationOptions){_, error in
            if let error = error{
              print("ERROR: \(error)")
            }
        }
      ~~~

    </div>
    </details>
    
    
</br>


### 4. 다음 카페/블로그 검색앱 만들기
- 기능: 다음 카페/블로그 글을 검색하고, 이름/작성일 기준으로 정렬하여 조회 할 수 있습니다.

- 프로젝트 코드: [🔗](https://github.com/oneoneoneoneoneoneone/Fastcampus-iOS/tree/main/P4/SubwayStation)

- 화면
    |<img src="https://user-images.githubusercontent.com/94464179/220095185-ac42021f-97e2-4352-aca2-e1dc5bcc8639.png" width="12%" height="12%" alt>| 
    |:--:|
    | *검색 리스트 화면* |

- 학습 내용
  - UISearchbar
  - NSURLRequest
    - 다음 검색 API 통신을 위해 사용한 라이브러리 입니다.
  - RxSwift / RxCocoa
  - MVVM Achitecture

- 주요 기능을 구현한 코드
  <details>
  <summary>API 통신</summary>
  <div markdown="1">

  - 네트워크 통신은 기본 제공되는 NSURLRequest라이브러리를 사용했습니다.
    ~~~swift
    //SearchBlogNetwork
      //SearchNetworkError - 미리 정의한 네트워크 에러 enum
      func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>>{
          guard let url = api.searchBlog(query: query).url else{
              return .just(.failure(.invalidURL))
          }

          let request = NSMutableURLRequest(url: url)
          request.httpMethod = "GET"
          request.setValue("KakaoAK -", forHTTPHeaderField: "Authorization")

          return session.rx.data(request: request as URLRequest)
              .map{data in
                  do{
                      //json encoding
                      let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                      return .success(blogData)
                  }catch{
                      return .failure(.invalidJSON)
                  }
              }
              .catch{_ in
                      .just(.failure(.networkError))
              }
              //옵저버블 > single
              //Single<Result<DKBlog, SearchNetworkError>>
              .asSingle()
      }
    ~~~

  </div>
  </details>   

  <details>
  <summary>정렬</summary>
  <div markdown="1">

  - ViewModel과 ViewController간에 AlertAction(정렬방식)이 선택되었을 때 동작
    ~~~swift
    //MainViewController
      viewModel.shouldPresentAlert
          .flatMap{alert -> Signal<AlertAction> in
              let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
              //Alert컨트롤러 생성 메소드 호출
              return self.presentAlertController(alertController, actions: alert.actions)
          }
          .emit(to: viewModel.alertActionTap)
          .disposed(by: disposeBag)  
    ~~~

  - alertActionTap되었을 때, 기존 CellData를 sortedType에 맞게 재정렬시키는 연산 수행
    ~~~swift
    //MainViewModel
      //filterView 선택 > alertSheet > type별로 액션을 구분
      let sortedType = alertActionTap
      .filter{
          switch $0 {
          case .title, .datetime:
              return true
          default:
              return false
          }
      }
      .startWith(.title)  //초기값

      //메인뷰의 액션으로 데이터처리 -> 리스트뷰에 값 셋팅
      Observable
          .combineLatest(
              sortedType, //PublishSubject<MainViewController.AlertAction>()
              cellData,
              resultSelector: model.sort
          )
          .bind(to: blogListViewModel.BlogCellData)
          .disposed(by: disposeBag)
    ~~~

  </div>
  </details>

  <details>
  <summary>검색</summary>
  <div markdown="1">

  - 검색버튼 이벤트 연결
    ~~~swift
    //SearchBar
      //searchButtonTap = searchButtonClicked(키보드의 검색 버튼) + search 커스텀 버튼 탭
      viewModel.searchButtonTap
          .asSignal()
          .emit(to: self.rx.endEditing)   //SearchBar에 endEditing 메소드를 Rx로 Reactive
          .disposed(by: disposeBag)
    ~~~

  - 검색버튼 탭 되었을 때 결과처리
    ~~~swift
    //SearchBar
      self.shouldLoadResult = searchButtonTap
          //
          .withLatestFrom(queryText) {$1 ?? ""}
          .filter{!$0.isEmpty}
          .distinctUntilChanged()
    ~~~   

  - 검색데이터 맵핑
    ~~~swift
    //MainViewModel
      let blogResult = searchBarViewModel.shouldLoadResult
      //파라미터 인자와 메소드 인자가 동일하면 클로저안써도 됨
          .flatMapLatest(model.searchBlog)
          .share()

      //예외처리하고 결과만 가져옴
      let blogValue = blogResult
          .compactMap(model.getBlogValue)

      //에러처리
      let blogError = blogResult
          .compactMap(model.getBlogError)

      let cellData = blogValue
      .map(model.getBlogListCellData)
      .debug("MainViewModel - cellData")
    ~~~      

  </div>
  </details>
    
      
</br>

    
### 5. 내 근처 편의점 찾기 앱
- 기능: 사용자의 현재위치를 받아와 편의점으로 검색한 점포를 지도에서 확인할 수 있습니다.

- 프로젝트 코드: [🔗](https://github.com/oneoneoneoneoneoneone/Fastcampus-iOS/tree/main/P5/FindCVS)

- 화면
    |<img src="https://user-images.githubusercontent.com/94464179/218811403-eeace868-3889-4fc7-a9d8-fbbce151f7b9.png" width="25%" height="25%" alt>|<img src="https://user-images.githubusercontent.com/94464179/218811403-eeace868-3889-4fc7-a9d8-fbbce151f7b9.png" width="25%" height="25%" alt>| 
    |:--:|:--:|
    | *리스트화면* | *알림추가화면* |

- 학습내용
  - DaumMap API
    - SDK 사용
  - RxSwift로 커스텀 메소드


</br>


### 6. 도서리뷰 앱 만들기
- 기능: 제목으로 검색한 책 제목/이미지 데이터를 활용해 리뷰를 작성하고 그 목록을 조회할 수 있습니다.

- 프로젝트 코드: [🔗](https://github.com/oneoneoneoneoneoneone/Fastcampus-iOS/tree/main/P5/BookReview)

- 화면
    |<img src="https://user-images.githubusercontent.com/94464179/220159735-8f41ee26-39df-4df1-a0b4-78119eab6aac.png" width="40%" height="40%" alt>|<img src="https://user-images.githubusercontent.com/94464179/220159759-d67f0dfa-9bb5-403f-a3ec-8f6580f09685.png" width="40%" height="40%" alt>|<img src= "https://user-images.githubusercontent.com/94464179/220159748-f8f2ff02-c76e-430b-a98b-795ea4ac9a06.png" width="40%" height="40%" alt>|
    |:--:|:--:|:--:|
    | *리스트 화면* | *리뷰 작성 화면* | *제목 검색 화면* |
    
- 학습내용
  - Naver 검색 API
  - Alamofire
  - MVP Achitecture
  - XCTest
  
- 주요 기능을 구현한 코드
  <details>
  <summary>책 검색</summary>
  <div markdown="1">

  - API호출을 위한 네트워크 통신은 Alamofire 라이브러리를 사용했습니다.
    ~~~swift
    //BookSearchManager
      AF
          .request(url, method: .get, parameters: prameters, headers: headers)
          .responseDecodable(of: BookSearchResponseModel.self){response in
              switch response.result{
              case .success(let result):
                  completionHandler(result.items)
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
          .resume()

    ~~~

  - UISearchBarDelegate의 검색버튼이 눌렸을 때 메소드로, 검색어가 확인되면 API 검색 후 테이블을 리로드합니다.
    ~~~swift
    //SearchBookPresenter
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          guard let searchText = searchBar.text else {return}

          //책 검색 데이터 가져옴. completionHandler([Book])
          bookSearchManager.request(from: searchText){ [weak self] newBooks in
              self?.books = newBooks
              self?.viewController.reloadView()
          }
      }

    ~~~

  </div>
  </details>

  <details>
  <summary>리뷰 저장(딜리게이트 패턴)</summary>
  <div markdown="1">

  - ViewController단에서는 presenter단에 프로토콜 딜리게이트를 전달??합니다.
    ~~~swift
    //SearchBookViewController
      private lazy var presenter = SearchBookPresenter(viewController: self, delegate: serachBookDelegate)

      private let serachBookDelegate: SearchBookDelegate

      init(searchBookDelegate: SearchBookDelegate){
          self.serachBookDelegate = searchBookDelegate

          super.init(nibName: nil, bundle: nil)
      }
    ~~~

  - 뷰컨트롤러에서 전달 된 딜리게이트로 초기화, 검색된 목록 중 하나가 선택되었을 때 셀 데이터를 딜리게이트로 전달합니다.
    ~~~swift
    //SearchBookPresenter
      private let delegate: SearchBookDelegate

      init(viewController: SearchBookProtocol, delegate: SearchBookDelegate) {
          self.viewController = viewController
          self.delegate = delegate
      }

      //tableView Cell 선택
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let selectedBook = books[indexPath.row]
          //선택된 Cell data 딜리게이트로 전달
          delegate.selectBook(selectedBook)

          viewController.close()
      }
    ~~~

  - 리뷰를 작성하는 ViewController단에서 딜리게이트를 상속받아 전달 된 셀 데이터 값을 화면에 업데이트 합니다.
    ~~~swift
    //ReviewWritePresenter
      extension ReviewWritePresenter: SearchBookDelegate{
          func selectBook(_ book: Book) {
              self.book = book
              viewController.updateViews(title: book.title, imageUrl: book.imageURL)
          }
      }
    ~~~

  </div>
  </details>

  <details>
  <summary>Unit Test</summary>
  <div markdown="1">

  - presenter에 대한 테스트 코드를 작성했습니다.
    ~~~swift
    //SearchBookPresenterTests
      override func setUp() {
          super.setUp()

          viewController = MockSearchBookViewController()
          bookSearchManager = MockBookSearchManager()
          delegate = MockDelegate()

          sut = SearchBookPresenter(viewController: viewController, delegate: delegate, bookSearchManager: bookSearchManager)
      }

      func test_searchBarSearchButtonClicked_호출될_때_request_성공(){
          bookSearchManager.needToSuccessRequest = true
          sut.searchBarSearchButtonClicked(UISearchBar())

          XCTAssertTrue(viewController.isCalledReloadView, "reloadView 실행")
      }

    ~~~

  - ViewController 등 테스트에 필요한 클래스들은 MockClass로 생성하여 사용했습니다.
    ~~~swift
       class MockSearchBookViewController: SearchBookProtocol{
          var isCalledSetupNavigationBar = false
          var isCalledSetupViews = false
          var isCalledClose = false
          var isCalledReloadView = false

          func setupNavigationBar() {
              isCalledSetupNavigationBar = true
          }

          func setupViews() {
              isCalledSetupViews = true
          }

          func close() {
              isCalledClose = true
          }

          func reloadView() {
              isCalledReloadView = true
          } 
      }
    ~~~

  </div>
  </details>

</br>
