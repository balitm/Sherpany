//
//  ModelNet.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class ModelNet {
    private static let kUsersURL = "http://jsonplaceholder.typicode.com/users"
    private static let kAlbumsURL = "http://jsonplaceholder.typicode.com/albums"

    enum Error: ErrorType {
        case URLFormat
    }

    enum Status: Int {
        case kNetNoop
        case kNetChecking
        case kNetExecuting
        case kNetFinished
        case kNetReady
        case kNetNonet
        case kNetNohost
    }

    func downloadUsers() throws {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        guard let usersURL = NSURL(string: ModelNet.kUsersURL) else {
            throw Error.URLFormat
        }
        dispatch_async(dispatch_get_global_queue(priority, 0), {
            if let data = NSData(contentsOfURL: usersURL) {
                self._processUsersJson(data)
            } else {
            }
//            dispatch_async(dispatch_get_main_queue()) {
//                // update some UI
//            }
        })
    }

    private func _processUsersJson(data: NSData) {
        do {
            let users = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.init(rawValue: 0)) as? [AnyObject]
            for item in users! {
                if let user = item as? [String: String] {
                    print("name: \(user["name"])")
                }
            }
        } catch {
        }

    }
}