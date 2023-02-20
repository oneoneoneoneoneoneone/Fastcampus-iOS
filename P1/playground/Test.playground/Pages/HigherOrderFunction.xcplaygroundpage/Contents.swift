//: [Previous](@previous)

import Foundation

//map - 배열의 요소에 접근 (기존배열.count = 새로운배열.count)
let numbers = [0,1,2,3]
let mapArray = numbers.map {
    return $0 * 2
}

print("map - \(mapArray)")


//filter
let numbers2 = [10,50,33,354,544,20]
let filterArray = numbers2.filter {
    $0 % 5 == 0
}

print("filter - \(filterArray)")


//reduce - 요소를 하나로 통합
let numbers3 = [0, 1, 2, 3]
let reduceResult = numbers3.reduce(4) {            //초기값
    print ("Result - \($0), Element - \($1)")    //result - 누적값, element - 요소
    return $0 + $1
}

print("reduce - \(reduceResult)")
