//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

print(arc4random_uniform(2) == 1)
print(arc4random_uniform(2) == 1)
print(arc4random_uniform(2) == 1)

let strings = ["Hi", "Hello", "Aloha"]
let anyObjects: [AnyObject] = strings

if let downcastStrings = anyObjects as? [String] {
    print("It's a [String]")
}
//