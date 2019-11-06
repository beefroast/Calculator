//
//  Stack.swift
//  Calculator
//
//  Created by Benjamin Frost on 6/11/19.
//  Copyright © 2019 Benjamin Frost. All rights reserved.
//

import Foundation

class StackElement<T> {
    
    let element: T
    let tail: StackElement<T>?
    
    init(element: T, tail: StackElement<T>? = nil) {
        self.element = element
        self.tail = tail
    }
    
}

class Stack<T> {
 
    var head: StackElement<T>?
    
    init(head: StackElement<T>? = nil) {
        self.head = nil
    }
    
    func push(elt: T) {
        self.head = StackElement.init(element: elt, tail: self.head)
    }
    
    func peek() -> T? {
        return self.head?.element
    }
    
    func pop() -> T? {
        let returnValue = self.peek()
        self.head = self.head?.tail
        return returnValue
    }
}




