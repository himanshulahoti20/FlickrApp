//
//  Photos.swift
//  Flickr
//
//  Created by Himanshu Lahoti on 29/06/22.
//

import Foundation
struct Photos : Codable {
    let page,pages,perpage,total : Int?
    let photo : [Photo]
}
