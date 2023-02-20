
//파라미터X, 리턴타입X
let hello = { () -> () in
    print("hello")
}
hello()

//파라미터O, 리턴타입O
let hello2 = { (name: String) -> (String) in
    return name
}
hello2("hello2")

//함수의 파라미터로 클로저를 사용
func doSomething(closure: () -> ()) {
    closure()
}
doSomething { () -> () in
    print("hello3")
}

//함수의 반환타입으로 클로저를 사용
func doSomething2() -> () -> () {
    return { () -> () in
        print("hello4")
    }
}
doSomething2()     //클로저 네임..
doSomething2()()   //클로저() ......

//후행클로저 - 마지막 매개변수로 전달되는 클로저만 사용가능
//파라미터, 반환값이 없으면 in까지 생략가능
doSomething() {
    print("hello3")
}

//다중후행클로저 - 첫번째 클로저는 매개변수 생략가능
func doSomething3(closure1: () -> (), closure2: () -> ()){
    closure1()
    closure2()
}

doSomething3 {
    print("closure1")
} closure2: {
    print("closure2")
}


//클로저 표현 간소화
func doSomething4(closure: (Int, Int, Int) -> Int){
    closure(1, 2, 3)
}

doSomething4 {
    $0+$1+$2
}

