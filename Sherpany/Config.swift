//
//  Config.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/17/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

struct Config: ConfigProtocol {
    let kBaseURL = "http://jsonplaceholder.typicode.com/"
    let kUsersPath = "users"
    let kAlbumsPath = "albums"
    let kPhotosPath = "photos"
    let kProviderType = DataProviderType.Alamofire //AsyncSession
    let kProcessorType = DataProcessorType.SwiftyJson
}
