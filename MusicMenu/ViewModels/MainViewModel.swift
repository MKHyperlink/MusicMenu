//
//  MainViewModel.swift
//  MusicMenu
//
//  Created by Mike on 2018/11/15.
//  Copyright © 2018 Mike. All rights reserved.
//


class MainViewModel: MainBehavior {
    
    func searchMusic(keyword: String, completion: @escaping ([MusicInfo]) -> Void) {
        
        SearchMusicManager.getInstance.search(keyword: keyword) { (result) in
            let musicInfos = result.results
            completion(musicInfos)
        }
    }
}
