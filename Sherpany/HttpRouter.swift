//
//  HttpRouter.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/19/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import Alamofire


enum HttpRouter: Alamofire.URLRequestConvertible {
    static let kBaseURL = NSURL(string: "http://jsonplaceholder.typicode.com/")!

    // values
    case Users
    case Albums
    case Photos

    // endpoint method
    var method: Alamofire.Method {
        return .GET
    }

    // endpoint path
    var path : String {
        switch self {
        case .Users:
            return "users"
        case .Albums:
            return "albums"
        case .Photos:
            return "photos"
        }
    }

    // endpoint parameters
    var parameters: [String : AnyObject]? {
        return nil
    }


    // URL generation routine
    var URLRequest: NSMutableURLRequest {

        let urlValue = HttpRouter.kBaseURL.URLByAppendingPathComponent(self.path)
        let mutableURLRequest = NSMutableURLRequest(URL: urlValue)
        mutableURLRequest.HTTPMethod = method.rawValue

        return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: self.parameters).0
    }
}