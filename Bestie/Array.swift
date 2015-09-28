//
//  Shuffle.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import Foundation

extension CollectionType where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
    
    func chunk(size: Int) -> [[Generator.Element]] {
        var temp: [Generator.Element] = []
        var final: [[Generator.Element]] = []
        
        for element in self {
            
            if temp.count < size {
                temp.append(element)
            }
            
            if temp.count == size {
                final.append(temp)
                temp.removeAll()
            }
        }
        
        return final
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

