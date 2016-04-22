//
//  AlamofireRouter.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/19/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import Alamofire


enum AlamofireRouter: Alamofire.URLRequestConvertible {
    static var kBaseURL: NSURL! = nil
    static var kURLs: DataURLs! = nil

    // values
    case Users
    case Albums
    case Photos

    static func setup(urls: DataURLs) {
        AlamofireRouter.kURLs = urls
        AlamofireRouter.kBaseURL = NSURL(string: urls.kBaseURL)!
    }

    // endpoint method
    var method: Alamofire.Method {
        return .GET
    }

    // endpoint path
    var path : String {
        switch self {
        case .Users:
            return AlamofireRouter.kURLs.kUsersPath
        case .Albums:
            return AlamofireRouter.kURLs.kAlbumsPath
        case .Photos:
            return AlamofireRouter.kURLs.kPhotosPath
        }
    }

    // endpoint parameters
    var parameters: [String : AnyObject]? {
        return nil
    }


    // URL generation routine
    var URLRequest: NSMutableURLRequest {
        let urlValue = AlamofireRouter.kBaseURL.URLByAppendingPathComponent(self.path)
        let mutableURLRequest = NSMutableURLRequest(URL: urlValue)
        mutableURLRequest.HTTPMethod = method.rawValue
        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: self.parameters).0
    }
}