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

	static func get(endpoint: String, access: Access, parameters: [String: String], with handler: @escaping (Data?, URLResponse?, Error?)->()) {
		let url = baseURL.appendingPathComponent("/\(endpoint)")
		var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

		components.queryItems = parameters.map({ return URLQueryItem(name: $0, value: $1) })

		var request = URLRequest(url: components.url!)

		request.httpMethod = "GET"
		request.setValue("Bearer \(access.token)", forHTTPHeaderField: "Authorization")

		URLSession.shared.dataTask(with: request, completionHandler: handler).resume()
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


extension Spotify {

	class Track: Decodable {

		let availableMarkets: [String]
		let discNumber: Int
		let duration: Int
		let isExplicit: Bool
		let href: URL
		let id: String
		let name: String
		let popularity: Int
		let trackNumber: Int

		enum CodingKeys: String, CodingKey {

			case availableMarkets = "available_markets"
			case discNumber = "disc_number"
			case duration = "duration_ms"
			case isExplicit = "explicit"
			case href
			case id
			case name
			case popularity
			case trackNumber = "track_number"
			
		}

	}

}


extension Spotify {

	class SearchResult: Decodable {

		let tracksResult: TracksResult?

		enum CodingKeys: String, CodingKey {

			case tracksResult = "tracks"
			
		}

	}

	class TracksResult: Decodable {

		let href: URL
		let items: [Track]

	}

}
