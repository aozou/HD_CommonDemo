//
//  ViewController.swift
//  swiftBaseTest
//
//  Created by  jiangminjie on 2018/1/24.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func segementTagAction(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.test()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func test() {
        
        let possibleNumber = "1234"
        let convertedNumber = Int(possibleNumber)
        let serverResponserCode : Int? = 404
        
        print("\(possibleNumber)","\(convertedNumber)","\(serverResponserCode)")
        
        /*
         *注意： 在 if 条件语句中使用常量和变量来创建一个可选绑定，仅在 if 语句的句中(body)中才能获取到值。
         相反，在 guard 语句中使用常量和变量来创建一个可选绑定，仅在 guard 语句外且在语句后才能获取到值，请参考提前退出。
         */
        if let frstNumber = Int("4"),let secondNumber = Int("43"),frstNumber < secondNumber && secondNumber < 100 {
            print("\(frstNumber) < \(secondNumber)")
            
        }
        
        let name = "hello"
        if name == "hello" {
            print("is ok")
        }
        //元组元素在7个以内才能直接比较
        if (1,"as") < (1,"bs")  {
            print("元组正确")
        }else{
            print("元组错误,BOOL类型不能比较")
        }
    
        //a??b 空和运算符
        //区间运算符
        for index in 1...5 {
            print("\(index) * 5 = \(index*5)")
        }
        let names = ["Anna","Alex","Brian","jack"]
        for i in 0..<names.count {
            print("第\(i+1)个人叫\(names[i])")
        }
        print("*********\n")
        for nameStr in names[2...] {
            print("name:\(nameStr)")
        }
        print("*********\n")
        for nameStr in names[...2] {
            print("name:\(nameStr)")
        }
        print("*********\n")
        
        //字符串和字符
        let quotation = """
        this is test show time, "yes hi  showsd ssze"
        hahah"123141414123" \
            zhahzhahah
        """
        print("\(quotation)")
        
        print("*********\n")
        let blackHeart = "\u{2665}"
        print("\(blackHeart)")
        
        let emptyString = ""
        let emptyString2 : String?
        if emptyString.isEmpty {
            print("Nothing to see here")
        }
//        if emptyString2?.isEmpty {
//            print("Nothing to see here 2")
//        }
        
        let greeting = "guten Tag!"
        let s1 = greeting[greeting.startIndex];
        let s2 = greeting[greeting.index(before: greeting.endIndex)]
        let s3 = greeting[greeting.index(after: greeting.startIndex)]
        let s4 = greeting.index(greeting.startIndex, offsetBy: 7)
        let s5 = greeting[s4]
        print("\(s1),\(s2),\(s3),\(s4),\(s5)")

        //集合类型
        var threeDoubles = Array(repeating: 0.0, count: 3)
        threeDoubles.insert(2.2, at: 3)
        
        var letss = Set<Character>()
        letss.insert("a")
        letss = []
        var favoriteGenrens:Set<String> = ["Rock","Sea"]
        favoriteGenrens.insert("re")
        
        let oddDigits:Set = [1,3,5,7,9]
        let evenDigits:Set = [0,2,4,6,8]
        let singleDigitPrimeNumbers:Set = [2,3,5,7]
        /*
         使用intersection(_:)方法根据两个集合中都包含的值创建的一个新的集合。
         使用symmetricDifference(_:)方法根据在一个集合中但不在两个集合中的值创建一个新的集合。
         使用union(_:)方法根据两个集合的值创建一个新的集合。
         使用subtracting(_:)方法根据不在该集合中的值创建一个新的集合。
         */
        let newSet_test1 = oddDigits.intersection(evenDigits);
        let newSet_test2 = oddDigits.symmetricDifference(singleDigitPrimeNumbers)
        let newSet_test3 = oddDigits.union(evenDigits);
        let newSet_test4 = oddDigits.subtracting(singleDigitPrimeNumbers);
        
        let newSet_test5 = oddDigits.intersection(singleDigitPrimeNumbers).sorted()
        let newSet_test6 = oddDigits.symmetricDifference(evenDigits).sorted()
        let newSet_test7 = oddDigits.union(singleDigitPrimeNumbers).sorted()
        let newSet_test8 = oddDigits.subtracting(evenDigits).sorted();
        print("\n")
        print("\(newSet_test1),\(newSet_test2),\(newSet_test3),\(newSet_test4)")
        print("\n")
        print("\(newSet_test5),\(newSet_test6),\(newSet_test7),\(newSet_test8)")
        
        /*
         使用“是否相等”运算符(==)来判断两个集合是否包含全部相同的值。
         使用isSubset(of:)方法来判断一个集合中的值是否也被包含在另外一个集合中。
         使用isSuperset(of:)方法来判断一个集合中包含另一个集合中所有的值。
         使用isStrictSubset(of:)或者isStrictSuperset(of:)方法来判断一个集合是否是另外一个集合的子集合或者父集合并且两个集合并不相等。
         使用isDisjoint(with:)方法来判断两个集合是否不含有相同的值(是否没有交集)。
         */
        let houseAnimals: Set = ["🐶", "🐱"]
        let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
        let cityAnimals: Set = ["🐦", "🐭"]
        houseAnimals.isSubset(of: farmAnimals)
        // true
        farmAnimals.isSuperset(of: houseAnimals)
        // true
        farmAnimals.isDisjoint(with: cityAnimals)
        // true
        print("\n")
        
        //控制流
        let minutes = 60
        for tickMark in 0..<minutes {
            print("\(tickMark)")
        }
        print("\n")
        
        let minutesInterval = 5
        for tickMark in stride(from: 0, to: minutes, by: minutesInterval) {
            print("\(tickMark)")
        }
        print("\n")
        
        let hours = 12
        let houInterval = 3
        for tickMark in stride(from: 0, through: hours, by: houInterval) {
            print("\(tickMark)")
        }
        print("\n")
        
        let somePoint = (1,0)
        switch somePoint {
        case (0,0):
            print("\(somePoint) is at the origin")
        case (_,0):
            print("\(somePoint) is on the x-axis")
            fallthrough
        case (0,_):
            print("\(somePoint) is on the y-axis")
        case (-2...2,-2...2):
            print("\(somePoint) is inside the box")
        default:
            print("\(somePoint) is outside of the box")
        }
     
        print("\n")
        greet(person: ["name3":"John"])
        
        if #available(iOS 10, *) {
            print("ios 10")
        } else {
            print("ios 10 NONO")
        }
        
        //闭包
        let nameSort = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        var reversedNames = nameSort.sorted(by: {(s1:String,s2:String) -> Bool in
            return s1 > s2
        })
        print(" \(reversedNames)")
    }
    
    func greet(person: [String:String]) -> Void {
        guard let name = person["name"] else {
            print("This is Error")
            return
        }
        print("Hello \(name)")
        

    }
    
}

