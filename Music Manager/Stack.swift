//
//  Stack.swift
//  Essentials
//
//  Created by Will Tyler on 5/19/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


class Stack<Element> {

	private var elements: [Element] = [Element]()
	private var height: Int = 0
	private var isFlipped = false

	private let max: Int?

	public var count: Int {
		get {
			return elements.count
		}
	}
	public var isEmpty: Bool {
		get {
			return count == 0
		}
	}

	//MARK: Constructors
	init() {
		max = nil
	}
	init(maxCount: Int) {
		precondition(maxCount >= 0, "Cannot create Stack with negative maxCount.")
		self.max = maxCount
	}
	init(with elements: Element..., maxCount: Int? = nil) {
		self.max = maxCount

		for element in elements {
			self.push(element)
		}
	}

	//MARK: Access
	/// Add an element to the top of the stack.
	public func push(_ new: Element...) {
		for element in new {
			if max != nil, height == max {
				if isFlipped {
					elements.removeLast()
				}
				else {
					elements.removeFirst()
				}
			}
			else {
				defer {
					height += 1
				}
			}

			if isFlipped {
				elements.insert(element, at: 0)
			}
			else {
				elements.append(element)
			}
		}
	}

	/// Remove and return the element from the stack at the specified index.
	public func pull(from index: Int) -> Element {
		defer {
			height -= 1
		}

		if !isFlipped {
			return elements.remove(at: index)
		}
		else {
			return elements.remove(at: count-1 - index)
		}
	}

	/// Remove and return the element at the top of the stack.
	public func pop() -> Element {
		defer {
			height -= 1
		}

		if !isFlipped {
			return elements.removeLast()
		}
		else {
			return elements.removeFirst()
		}
	}

	/// Reverse the order of the stack.
	public func flip() {
		isFlipped.toggle()
	}

	/// Return the member at the top of the stack.
	public func peek() -> Element {
		return isFlipped ? elements.first! : elements.last!
	}

	/// Return the member at the specified index.
	public subscript(index: Int) -> Element {
		get {
			return !isFlipped ? elements[index] : elements[count-1 - index]
		}
	}

}
