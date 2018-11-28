//
//  SearchMusicManager.swift
//  MusicMenu
//
//  Created by Mike on 2018/11/15.
//  Copyright © 2018 Mike. All rights reserved.
//

import Alamofire

class SearchMusicManager {
    
    private let BASE_URL = "https://itunes.apple.com"
    
    private static let instance = SearchMusicManager()
    
    class var getInstance: SearchMusicManager {
        return instance
    }
    
    enum SearchParameters: String {
        case term
    }
    
    public func search(keyword: String, completion: @escaping (_ searchResult: SearchResult) -> Void ) {
        
        let keyword = keyword.replacingOccurrences(of: " ", with: "+")
        
        let url = "\(BASE_URL)/search?\(SearchParameters.term)=\(keyword)"
        let headers = [String: String]()
        let parameters = [String: Any]()
        
        DispatchQueue(label: "com.mike.search").async {
            Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseData { response in
                
                if let resVal = response.result.value {
                    do {
                        let decoder = JSONDecoder()
                        let searchResult = try decoder.decode(SearchResult.self, from: resVal)
                        completion(searchResult)
                    } catch let jsonErr {
                        print("json parsing error:", jsonErr)
                    }
                } else {
                    print("Get empty result for search.")
                }
            }
        }
    }
}
