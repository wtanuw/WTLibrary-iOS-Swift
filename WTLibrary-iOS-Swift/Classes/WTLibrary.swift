//
//  WTLibrary.swift
//  Pods
//
//  Created by iMac on 12/16/15.
//
//

import Foundation

//MARK:

//swift 2.0 remove String function
//public func print<T>(object: T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
//    Swift.print("\(file.lastPathComponent.stringByDeletingPathExtension).\(function)[\(line)]: \(object)")
//}

#if DEBUG
    func dLog(message: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
    }
#else
    func dLog(message: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {}
#endif
func aLog(message: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
}

//MARK:

#if DEBUG
    public func WatLog(message: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {
        NSLog("[\(filename.lastPathComponent):\(line):\(function)] - \(message)")
    }
#else
    public func WatLog(message: String, filename: String = __FILE__, function: String = __FUNCTION__, line: Int = __LINE__) {}
#endif

//MARK:

extension String {
    var ns: NSString {
        return self as NSString
    }
    var pathExtension: String? {
        return ns.pathExtension
    }
    var lastPathComponent: String? {
        return ns.lastPathComponent
    }
}

//extension String {
//    var pathExtension: String? {
//        return NSURL(fileURLWithPath: self).pathExtension
//    }
//    var lastPathComponent: String? {
//        return NSURL(fileURLWithPath: self).lastPathComponent
//    }
//}

//MARK:

//  RACObserve(object, property) is equivalent to [object rac_valuesForKeyPath:@"property" observer:self].
//  RAC(object, property) = signal is equivalent to [signal setKeyPath:@"property" onObject:object].

// AnyProperty init Value <~ SignalProducer // mutableProperty <~ producer
// AnyProperty init Value <~ Signal // mutableProperty <~ signal
// MutablePropertyType <~ Signal
// MutablePropertyType <~ SignalProducer // property <~ producer.startWithSignal
// MutablePropertyType <~ PropertyType // destinationProperty <~ sourceProperty.producer

//MARK:

//        let (signal, observer) = Signal<Int,NoError>.pipe()
//        observer.sendNext(5)
//        let (producer, sink) = SignalProducer<Int, NoError>.buffer()
//        let producerM = producer
//            .map { (a) -> AnyObject? in
//                a
//        }

//        let (signal, observer) = Signal<Int, NoError>.pipe()
//        signal
//            .reduce(1) { $0 * $1 }
//            .observeNext { next in print(next) }
//
//        observer.sendNext(1)     // Not printed
//        observer.sendNext(2)     // Prints 2
//        observer.sendNext(3)     // Not printed
//        observer.sendNext(4)     // prints 4
//
//
//        signal.observe(Signal.Observer { event in
//            switch event {
//            case let .Next(next):
//                print("Next: \(next)")
//            case let .Failed(error):
//                print("Failed: \(error)")
//            case .Completed:
//                print("Completed")
//            case .Interrupted:
//                print("Interrupted")
//            }
//            })


//MARK:

prefix operator √ {}
prefix func √ (number: Double) -> Double {
    return sqrt(number)
}

infix operator ± { associativity left precedence 140 }
func ± (left: Double, right: Double) -> (Double, Double) {
    return (left + right, left - right)
}

prefix operator ± {}
prefix func ± (value: Double) -> (Double, Double) {
    return 0 ± value
}

//MARK:

// Array<Element> -> Dictionary<U:[Element]>
public extension SequenceType {
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
        var dict: [U:[Generator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
// Dictionary<U:[Element] -> Array<[Element]>
public extension Dictionary {
    func group(keyFunc: (value1: Key, value2: Key) -> Bool) -> [Value] {
        var array: [Value] = []
        let keys = self.keys
        let sortKey = keys.sort ({ (aa, bb) -> Bool in
            return keyFunc(value1: aa, value2: bb)
        })
        for key in sortKey {
            let value = self[key]!
            array += [value]
        }
        return array
    }
}

public extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    
}

// Dictionary += Dictionary
public func += <K, V>(inout left: Dictionary<K, V>, right: Dictionary<K, V>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

// Dictionary + Dictionary
public func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>)
    -> Dictionary<K,V>
{
    var map = Dictionary<K,V>()
    for (k, v) in left {
        map[k] = v
    }
    for (k, v) in right {
        map[k] = v
    }
    return map
}
