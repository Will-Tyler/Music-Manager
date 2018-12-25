//
//  XMLDelegate.swift
//  Music Manager
//
//  Created by Will Tyler on 12/25/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


final class XMLDelegate: NSObject, XMLParserDelegate {

	private var currentElementType: ElementType {
		get {
			return typeStack.peek()
		}
	}
	private var keyStack = Stack<String>()
	private var typeStack = Stack<ElementType>()
	private var dictStack = Stack<[String: Any]>()
	private var currentDict = [String: Any]()

	func parserDidStartDocument(_ parser: XMLParser) {
		print("Parsing the library...")
	}

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
		let elementType = ElementType(rawValue: elementName)!

		typeStack.push(elementType)

		switch elementType {
		case .dict:
			if !currentDict.isEmpty {
				dictStack.push(currentDict)
				currentDict = [:]
			}

		case .valueTrue:
			let key = keyStack.pop()

			currentDict[key] = true

		case .valueFalse:
			let key = keyStack.pop()

			currentDict[key] = false

		default: break
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		switch currentElementType {
		case .key:
			keyStack.push(string)

		case .date, .integer, .string:
			let key = keyStack.pop()

			currentDict[key] = string

		default: break
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		let elementType = typeStack.pop()

		switch elementType {
		case .dict:
			if !dictStack.isEmpty {
				let currentDict = self.currentDict
				var previousDict = dictStack.pop()
				let key = keyStack.pop()

				previousDict[key] = currentDict
				self.currentDict = previousDict
			}

		default: break
		}
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		print("Finished parsing the library...")
	}

}
