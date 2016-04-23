//
//  AsyncDataProvider.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class AsyncDataProvider: DataProviderBase, DataProviderProtocol {
    var indicatorDelegate: ModelNetworkIndicatorDelegate! = nil
    private var _pendingTasks = 0


    func setup(urls: DataURLs) {
        URLRouter.setup(urls)
    }

    private func _processData<T>(url: NSURL, checkStatus: Bool = true, function: (data: NSData) -> T, finished: (data: T) -> Void) {
        if checkStatus && status != Status.kNetFinished && status != Status.kNetNoop {
            return
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        status = Status.kNetExecuting
        assert(_pendingTasks >= 0)
        if _pendingTasks == 0 {
            indicatorDelegate?.show()
        }
        _pendingTasks += 1
        print("> pending: \(_pendingTasks)")
        dispatch_async(dispatch_get_global_queue(priority, 0), {
            if let data = NSData(contentsOfURL: url) {
                let result = function(data: data)
                dispatch_sync(dispatch_get_main_queue()) {
                    finished(data: result)
                    self.status = Status.kNetFinished
                    self._pendingTasks -= 1
                    print("< pending: \(self._pendingTasks)")
                    assert(self._pendingTasks >= 0)
                    if self._pendingTasks == 0 {
                        self.indicatorDelegate?.hide()
                    }
                }
            } else {
                self.status = Status.kNetNoHost
            }
        })
    }

    func processUsers(finished: (data: [UserData]?) -> Void) {
        _processData(URLRouter.Users.url, function: self.dataProcessor.processUsers, finished: finished)
    }

    func processAlbums(finished: (data: [AlbumData]?) -> Void) {
        _processData(URLRouter.Albums.url, function: self.dataProcessor.processAlbums, finished: finished)
    }

    func processPhotos(finished: (data: [PhotoData]?) -> Void) {
        _processData(URLRouter.Photos.url, function: self.dataProcessor.processPhotos, finished: finished)
    }

    func processPicture(url: NSURL, finished: (data: NSData?) -> Void, progress: (Float) -> Void) {
        _processData(url, checkStatus: false, function: self.dataProcessor.processPictureData, finished: finished)
    }

    func hasPendingTask() -> Bool {
        assert(_pendingTasks >= 0)
        return _pendingTasks > 0
    }
}