//
//  MemoryAddress.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 07/05/24.
//

import Foundation

struct MemoryAddress<T>: CustomStringConvertible {

    let intValue: Int

    var description: String {
        let length = 2 + 2 * MemoryLayout<UnsafeRawPointer>.size
        return String(format: "%0\(length)p", intValue)
    }

    // for structures
    init(of structPointer: UnsafePointer<T>) {
        intValue = Int(bitPattern: structPointer)
    }
    
    func address(o: UnsafeRawPointer) -> Int {
        return Int(bitPattern: o)
    }

    func addressHeap<T: AnyObject>(o: T) -> Int {
        return unsafeBitCast(o, to: Int.self)
    }
}

extension MemoryAddress where T: AnyObject {

    // for classes
    init(of classInstance: T) {
        intValue = unsafeBitCast(classInstance, to: Int.self)
        // or      Int(bitPattern: Unmanaged<T>.passUnretained(classInstance).toOpaque())
    }
    
}

/* usage
 
 class MyClass { let foo = 42 }
 var classInstance = MyClass()
 let classInstanceAddress = MemoryAddress(of: classInstance) // and not &classInstance
 print(String(format: "%018p", classInstanceAddress.intValue))
 print(classInstanceAddress)
 
 struct MyStruct { let foo = 1 } // using empty struct gives weird results (see StackOverflow comments)
 var structInstance = MyStruct()
 let structInstanceAddress = MemoryAddress(of: &structInstance)
 print(String(format: "%018p", structInstanceAddress.intValue))
 print(structInstanceAddress)
 
 */
