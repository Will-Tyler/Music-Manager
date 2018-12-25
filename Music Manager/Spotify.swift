//
//  Spotify.swift
//  Music Manager
//
//  Created by Will Tyler on 12/25/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


class Spotify {

	private static let baseURL = URL(string: "https://api.spotify.com/v1")!

	static func get(endpoint: String, access: Access, parameters: [String: String], with handler: (Data?, URLResponse?, Error?)->()) {
		let url = baseURL.appendingPathComponent("/\(endpoint)")
	}

}


extension Spotify {

	class Access: Decodable {

		let token: String
		let type: String
		let expiresIn: Int
		let scope: String

		enum CodingKeys: String, CodingKey {

			case token = "access_token"
			case type = "token_type"
			case expiresIn = "expires_in"
			case scope

		}

	}

}
