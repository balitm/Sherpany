//
//  Config.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/17/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

struct HttpJsonURLs: DataURLs {
    var kUsersURL = NSURL(string: "http://jsonplaceholder.typicode.com/users")!
    var kAlbumsURL = NSURL(string: "http://jsonplaceholder.typicode.com/albums")!
    var kPhotosURL = NSURL(string: "http://jsonplaceholder.typicode.com/photos")!
}
