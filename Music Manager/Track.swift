//
//  Track.swift
//  Music Manager
//
//  Created by Will Tyler on 12/25/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import Foundation


struct Track: Decodable {

	let id: Int
	let name: String
	let artist: String
	let albumArtist: String
	let composer: String?
	let album: String
	let genre: String
	let kind: String
	let size: Int
	let totalTime: Int
	let discNumber: Int
	let discCount: Int
	let trackNumber: Int
	let trackCount: Int?
	let year: Int
	let persistentID: String

	private enum CodingKeys: String, CodingKey {

		case id = "Track ID"
		case name = "Name"
		case artist = "Artist"
		case albumArtist = "Album Artist"
		case composer = "Composer"
		case album = "Album"
		case genre = "Genre"
		case kind = "Kind"
		case size = "Size"
		case totalTime = "Total Time"
		case discNumber = "Disc Number"
		case discCount = "Disc Count"
		case trackNumber = "Track Number"
		case trackCount = "Track Count"
		case year = "Year"
		case persistentID = "Persistent ID"

	}

}
