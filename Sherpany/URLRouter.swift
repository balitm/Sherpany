//
//  URLRouter.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/20/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

enum URLRouter {
    static var kBaseURL: NSURL! = nil
    static var kURLs: DataURLs! = nil

    // values
    case Users
    case Albums
    case Photos

    static func setup(urls: DataURLs) {
        URLRouter.kURLs = urls
        guard let url = NSURL(string: urls.kBaseURL) else {
            return
        }
        URLRouter.kBaseURL = url
    }

    // endpoint method
    var method: String {
        return "GET"
    }

    // endpoint path
    var path : String {
        switch self {
        case .Users:
            return URLRouter.kURLs.kUsersPath
        case .Albums:
            return URLRouter.kURLs.kAlbumsPath
        case .Photos:
            return URLRouter.kURLs.kPhotosPath
        }
    }

    // endpoint parameters
    var parameters: [String : AnyObject]? {
        return nil
    }

    var url: NSURL {
        switch self {
        case .Users:
            return NSURL(string: URLRouter.kURLs.kUsersPath, relativeToURL: URLRouter.kBaseURL)!
        case .Albums:
            return NSURL(string: URLRouter.kURLs.kAlbumsPath, relativeToURL: URLRouter.kBaseURL)!
        case .Photos:
            return NSURL(string: URLRouter.kURLs.kPhotosPath, relativeToURL: URLRouter.kBaseURL)!
        }
    }

    // URL generation routine
    var URLRequest: NSMutableURLRequest {
        let urlValue = URLRouter.kBaseURL.URLByAppendingPathComponent(self.path)
        let mutableURLRequest = NSMutableURLRequest(URL: urlValue)
        mutableURLRequest.HTTPMethod = method
        return mutableURLRequest
    }
}
