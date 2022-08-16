//
//  Constants.swift
//  Flickr
//
//  Created by Himanshu Lahoti on 30/06/22.
//

import Foundation
class Constants : NSObject {
    static var perPage = 500
    static let apiKey = "2645693b86f047157222147c59ed7bcd"
    static let apiUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&per_page=\(perPage)"
    static let imageUrl = "https://farm%d.staticflickr.com/%@/%@_%@_n.jpg"
}
