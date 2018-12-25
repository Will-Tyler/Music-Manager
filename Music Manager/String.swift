//
//  String.swift
//  Music Manager
//
//  Created by Will Tyler on 12/25/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


extension String {

	func toBase64() -> String {
		return Data(self.utf8).base64EncodedString()
	}

}
