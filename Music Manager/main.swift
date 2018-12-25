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
let tracks = try! decoder.decode([Track].self, from: jsonData)

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

for track in tracks {

}
