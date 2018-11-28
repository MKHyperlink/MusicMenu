//
//  SearchResult.swift
//  MusicMenu
//
//  Created by Mike on 2018/11/15.
//  Copyright © 2018 Mike. All rights reserved.
//

struct SearchResult: Codable {
    var resultCount: Int
    var results: [MusicInfo]
}

struct MusicInfo: Codable {
    var wrapperType: String?
    var kind: String?
    var trackName: String?
    var artistName: String?
    var collectionName: String?
    var censoredName: String?
    var artworkUrl100: String?
    var artworkUrl60:String?
    var viewURL: String?
    var previewUrl: String?
}
