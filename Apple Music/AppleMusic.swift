//
//  Apple Music.swift
//  Music Manager
//
//  Created by Will Tyler on 7/15/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation
import JWT


class AppleMusic {

	private static let keyID = "PSA2MGVH6Z"
	private static let teamID = "83A9Z5EMT8"
	private static var devToken: Any {
		get {
			return ["alg": "ES256", "kid": AppleMusic.keyID, "iat": Date().timeIntervalSince1970]
		}
	}

}
