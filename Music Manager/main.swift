//
//  main.swift
//  Music Manager
//
//  Created by Will Tyler on 12/24/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


let fileManager = FileManager.default
let currentPath = fileManager.currentDirectoryPath

print(currentPath)

let jsonFileURL = URL(fileURLWithPath: "Tracks.json")
let jsonData = try! Data(contentsOf: jsonFileURL)
let decoder = JSONDecoder()
let tracks = try! decoder.decode([Track].self, from: jsonData)

for track in tracks {
	print(track.name)
}
