//
//  main.swift
//  Music Manager
//
//  Created by Will Tyler on 12/24/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


print("Loading tracks...")

let jsonFileURL = URL(fileURLWithPath: "Tracks.json")
let jsonData = try! Data(contentsOf: jsonFileURL)
let decoder = JSONDecoder()
let iTunesTracks = try! decoder.decode([Track].self, from: jsonData)

print("Tracks loaded...", "Getting Spotify access token...", separator: "\n")

let spotifyInfo = try! String(contentsOfFile: "Spotify.txt").split(separator: "\n")

assert(spotifyInfo.count == 2)

let clientID = spotifyInfo.first!
let clientSecret = spotifyInfo.last!
let url = URL(string: "https://accounts.spotify.com/api/token")!
var request = URLRequest(url: url)

request.httpMethod = "POST"
request.addValue("Basic \("\(clientID):\(clientSecret)".toBase64())", forHTTPHeaderField: "Authorization")
request.httpBody = "grant_type=client_credentials".data(using: .ascii)

var access: Spotify.Access!
let semaphore = DispatchSemaphore(value: 0)
let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
	defer {
		semaphore.signal()
	}

	guard error == nil else {
		print(error!.localizedDescription)
		return
	}
	guard let data = data else {
		return
	}

	access = try! decoder.decode(Spotify.Access.self, from: data)
})

dataTask.resume()
semaphore.wait()

print("Got access token...", "Searching songs in Spotify...", separator: "\n")

var failedTracks = [Track]()
var spotifyTracks: [Spotify.Track] = [] {
	didSet {
		if let last = spotifyTracks.last {
			print(last.name)
		}
	}
}
var index = 0

while index < iTunesTracks.count {
	let track = iTunesTracks[index]
	let parameters = [
		"q": "\"\(track.name)\"artist:\"\(track.artist)\"",
		"type": "track",
		"limit": "1"
	]

	Spotify.get(endpoint: "search", access: access, parameters: parameters, with: { (data, response, error) in
		var foundMatch = false

		defer {
			index += 1
			semaphore.signal()

			if !foundMatch {
				failedTracks.append(track)
			}
		}

		guard error == nil else {
			print(error!.localizedDescription)
			return
		}
		guard let data = data, let response = response else {
			return
		}
		guard response.statusCode != 429 else {
			index -= 1
			foundMatch = true // trying again actually
			return
		}
		guard response.statusCode == 200 else {
			return
		}

		let result = try! decoder.decode(Spotify.SearchResult.self, from: data)
		let tracks = result.tracksResult.items

		if let firstTrack = tracks.first {
			spotifyTracks.append(firstTrack)
			foundMatch = true
		}
	})

	semaphore.wait()
}

print("Done searching tracks on Spotify...", "Found \(spotifyTracks.count) matches for \(iTunesTracks.count) songs...", separator: "\n")
print("Failed to find matches for \(failedTracks.count) songs...", "Saving failed track names to 'Failed.txt'...", separator: "\n")

let failedNames = failedTracks.map({ return $0.name })

try! failedNames.joined(separator: "\n").appending("\n").write(toFile: "Failed.txt", atomically: true, encoding: .utf8)

var spotifyIDs = spotifyTracks.map({ return $0.id })

let authorizeURL = URL(string: "https://accounts.spotify.com/authorize")!
let parameters: [String: String] = [
	"client_id": String(clientID),
	"response_type": "token",
	"redirect_uri": "https://willtyler98.github.io/",
	"scope": "user-library-modify"
]
var components = URLComponents(url: authorizeURL, resolvingAgainstBaseURL: true)!

components.queryItems = parameters.map({ return URLQueryItem(name: $0, value: $1) })

request = URLRequest(url: components.url!)
request.httpMethod = "GET"

print(request.url!, "Open this url and get the info when it redirects you...", separator: "\n")
print("Type 'Ready' when UserAccess.txt is ready...")

guard readLine() == "Ready" else {
	print("Quitting...")
	exit(0)
}

let userAccessURL = URL(fileURLWithPath: "UserAccess.txt")
let userAccess = try! decoder.decode(Spotify.Access.self, from: Data(contentsOf: userAccessURL))

while !spotifyIDs.isEmpty {
	let ids: [String]

	if spotifyIDs.count >= 50 {
		ids = Array(spotifyIDs[0..<50])
		spotifyIDs.removeFirst(50)
	}
	else {
		ids = spotifyIDs
		spotifyIDs.removeAll()
	}

	let json = [
		"ids": ids
	]
	
	Spotify.put(endpoint: "me/tracks", access: userAccess, json: json, with: { (data, response, error) in
		defer {
			semaphore.signal()
		}

		guard error == nil else {
			print(error!.localizedDescription)
			return
		}
		guard let response = response else {
			return
		}

		if response.statusCode != 200 {
			print("Status Code: \(response.statusCode)")
		}
		else {
			print("Success!")
		}
		if let data = data {
			let content = String(data: data, encoding: .utf8)!

			print(content)
		}
	})

	semaphore.wait()
}
