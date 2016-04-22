//
//  AlamofireDataProvider.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/19/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import Alamofire


class AlamofireDataProvider: DataProviderBase, DataProviderProtocol {
//    var urls: DataURLs! = nil
    private let _queue = dispatch_queue_create("hu.kil-dev.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)

    func setup(urls: DataURLs) {
        AlamofireRouter.setup(urls)
    }

    private func _processData<T>(data: NSData, function: (data: NSData) -> T, finished: (data: T) -> Void) {
        let result = function(data: data)
        dispatch_async(dispatch_get_main_queue()) {
            finished(data: result)
            self.status = Status.kNetFinished
        }
    }

    func processUsers(finished: (data: [UserData]?) -> Void) {
        Alamofire.request(AlamofireRouter.Users)
            .responseData(queue: _queue, completionHandler: { response in
                guard response.result.isSuccess else {
                    print("Error while getting user list: \(response.result.error)")
                    finished(data: nil)
                    return
                }

                guard let data = response.result.value else {
                    finished(data: nil)
                    return
                }
                self._processData(data, function: self.dataProcessor.processUsers, finished: finished)
            })
    }

    func processAlbums(finished: (data: [AlbumData]?) -> Void) {
        Alamofire.request(AlamofireRouter.Albums)
            .responseData(queue: _queue, completionHandler: { response in
                guard response.result.isSuccess else {
                    print("Error while getting album list: \(response.result.error)")
                    finished(data: nil)
                    return
                }

                guard let data = response.result.value else {
                    finished(data: nil)
                    return
                }
                self._processData(data, function: self.dataProcessor.processAlbums, finished: finished)
            })
    }

    func processPhotos(finished: (data: [PhotoData]?) -> Void) {
        Alamofire.request(AlamofireRouter.Photos)
            .responseData(queue: _queue, completionHandler: { response in
                guard response.result.isSuccess else {
                    print("Error while getting photo list: \(response.result.error)")
                    finished(data: nil)
                    return
                }

                guard let data = response.result.value else {
                    finished(data: nil)
                    return
                }
                self._processData(data, function: self.dataProcessor.processPhotos, finished: finished)
            })
    }

    func processPicture(url: NSURL, finished: (data: NSData?) -> Void, progress: (Float) -> Void) {
        Alamofire.request(.GET, url).responseData { response in
            guard let data = response.result.value else {
                finished(data: nil)
                return
            }
            finished(data: data)
        }
    }

    func hasPendingTask() -> Bool {
        return false
    }
}
