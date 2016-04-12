//
//  Config.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/17/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

struct Config: DataURLs, ModelTypes {
    let kUsersURL = NSURL(string: "http://jsonplaceholder.typicode.com/users")!
    let kAlbumsURL = NSURL(string: "http://jsonplaceholder.typicode.com/albums")!
    let kPhotosURL = NSURL(string: "http://jsonplaceholder.typicode.com/photos")!
    let kProviderType = DataProviderType.AsyncSession
    let kProcessorType = DataProcessorType.Json
}
