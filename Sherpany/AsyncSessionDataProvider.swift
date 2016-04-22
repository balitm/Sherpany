//
//  AsyncSessionDataProvider.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/1/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class Download {
}

class DownloadData<T>: Download {
    private let _closure: (data: [T]?) -> Void

    init(closure: (data: [T]?) -> Void) {
        _closure = closure
        super.init()
    }
}

class DownloadPicture: Download {
    private let _closure: (data: NSData?) -> Void
    private let _progressClosure: (Float) -> Void

    init(closure: (data: NSData?) -> Void, progressClosure: (Float) -> Void) {
        _closure = closure
        _progressClosure = progressClosure
        super.init()
    }
}


class AsyncSessionDataProvider: DataProviderBase, DataProviderProtocol {
    private var _downloads = [String: Download]()
    private var _session: NSURLSession! = nil


    override init() {
        super.init()

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        _session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    func setup(urls: DataURLs) {
        URLRouter.setup(urls)
    }

    private func _startProcessing<T, U where U: Download>(request: NSURLRequest, finished: (data: T?) -> Void, download: U) {
        let urlString = request.URL!.absoluteString
        assert(_downloads[urlString] == nil)
        _downloads[urlString] = download
        let task = _session.downloadTaskWithRequest(request)
        task.resume()
    }

    func processUsers(finished: (data: [UserData]?) -> Void) {
        let download = DownloadData(closure: finished)
        _startProcessing(URLRouter.Users.URLRequest, finished: finished, download: download)
    }

    func processAlbums(finished: (data: [AlbumData]?) -> Void) {
        let download = DownloadData(closure: finished)
        _startProcessing(URLRouter.Albums.URLRequest, finished: finished, download: download)
    }

    func processPhotos(finished: (data: [PhotoData]?) -> Void) {
        let download = DownloadData(closure: finished)
        _startProcessing(URLRouter.Photos.URLRequest, finished: finished, download: download)
    }

    func processPicture(url: NSURL, finished: (data: NSData?) -> Void, progress: (Float) -> Void) {
        let download = DownloadPicture(closure: finished, progressClosure: progress)
        _startProcessing(NSURLRequest(URL: url), finished: finished, download: download)
    }

    func hasPendingTask() -> Bool {
        return !_downloads.isEmpty
    }
}

extension AsyncSessionDataProvider: NSURLSessionDelegate {
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        status = Status.kNetError
    }
}

extension AsyncSessionDataProvider: NSURLSessionDownloadDelegate {
    private func _processData<T>(url: NSURL, function: (data: NSData) -> T, finished: (data: T) -> Void) {
        let data = NSData(contentsOfURL: url)
        let result = function(data: data!)
        dispatch_async(dispatch_get_main_queue()) {
            finished(data: result)
            self.status = Status.kNetFinished
        }
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        guard let reqURL = downloadTask.originalRequest?.URL else {
            return
        }
        guard let download = _downloads[reqURL.absoluteString] else {
            assert(false)
            return
        }
        switch reqURL.absoluteURL {
        case URLRouter.Users.url.absoluteURL:
            guard let d = download as? DownloadData<UserData> else {
                break
            }
            _processData(location, function: dataProcessor.processUsers, finished: d._closure)
        case URLRouter.Albums.url.absoluteURL:
            guard let d = download as? DownloadData<AlbumData> else {
                break
            }
            _processData(location, function: dataProcessor.processAlbums, finished: d._closure)
        case URLRouter.Photos.url.absoluteURL:
            guard let d = download as? DownloadData<PhotoData> else {
                break
            }
            _processData(location, function: dataProcessor.processPhotos, finished: d._closure)
        default:
            guard let d = download as? DownloadPicture else {
                break
            }
            _processData(location, function: dataProcessor.processPictureData, finished: d._closure)
        }
        _downloads[reqURL.absoluteString] = nil
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("bytes \(bytesWritten) - \(totalBytesWritten) from \(totalBytesExpectedToWrite)")
        guard let reqURL = downloadTask.originalRequest?.URL else {
            return
        }
        guard let download = _downloads[reqURL.absoluteString] else {
            assert(false)
            return
        }
        guard let d = download as? DownloadPicture else {
            return
        }
        d._progressClosure(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
}