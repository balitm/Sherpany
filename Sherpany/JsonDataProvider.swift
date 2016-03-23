//
//  JsonDataProvider.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class JsonDataProvider : ModelDataProvider {
    // Errors to handle via throw/catch.
    enum Error: ErrorType {
        case URLFormat
    }

    // Possible network statuses.
    enum Status {
        case kNetNoop
        case kNetExecuting
        case kNetFinished
        case kNetNoHost
    }

    var status = Status.kNetNoop


    // MARK: - Async download and process JSON data of users, albums and photos.

    private func _processData<T>(url: NSURL, checkStatus: Bool = true, function: (data: NSData) -> T, finished: (data: T) -> Void) {
        if checkStatus && status != Status.kNetFinished && status != Status.kNetNoop {
            return
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        status = Status.kNetExecuting
        dispatch_async(dispatch_get_global_queue(priority, 0), {
            if let data = NSData(contentsOfURL: url) {
                let result = function(data: data)
                dispatch_async(dispatch_get_main_queue()) {
                    finished(data: result)
                    self.status = Status.kNetFinished
                }
            } else {
                self.status = Status.kNetNoHost
            }
        })
    }

    func processUsers(url: NSURL, finished: (data: [UserData]?) -> Void) {
        _processData(url, function: self._processUsersJson, finished: finished)
    }

    func processAlbums(url: NSURL, finished: (data: [AlbumData]?) -> Void) {
        _processData(url, function: self._processAlbumsJson, finished: finished)
    }

    func processPhotos(url: NSURL, finished: (data: [PhotoData]?) -> Void) {
        _processData(url, function: self._processPhotosJson, finished: finished)
    }

    func processPicture(url: NSURL, finished: (data: NSData?) -> Void) {
        _processData(url, checkStatus: false, function: self._processPictureData, finished: finished)
    }


    // MARK: - private helpers to process JSON data of users, albums and photos.

    private func _processUsersJson(data: NSData) -> [UserData]? {
        do {
            let users = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]]
            var result = [UserData]()
            for item in users! {
                var userData = UserData()
                if let userId = item["id"] as? Int {
                    userData.userId = Int16(userId)
                }
                if let name = item["name"] as? String {
                    userData.name = name
                }
                if let email = item["email"] as? String {
                    userData.email = email
                }
                if let company = item["company"] as? [String:String] {
                    if let catchPhrase = company["catchPhrase"] {
                        userData.catchPhrase = catchPhrase
                    }
                }
                result.append(userData)
            }
            return result
        } catch {
            self.status = Status.kNetNoHost
        }
        return nil;
    }

    private func _processAlbumsJson(data: NSData) -> [AlbumData]? {
        do {
            let albums = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]]
            var result = [AlbumData]()
            for item in albums! {
                var album = AlbumData()
                if let albumId = item["id"] as? Int {
                    album.albumId = Int16(albumId)
                }
                if let userId = item["userId"] as? Int {
                    album.userId = Int16(userId)
                }
                if let title = item["title"] as? String {
                    album.title = title
                }
                result.append(album)
            }
            return result
        } catch {
            self.status = Status.kNetNoHost
        }
        return nil;
    }

    private func _processPhotosJson(data: NSData) -> [PhotoData]? {
        do {
            let photos = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [[String: AnyObject]]
            var result = [PhotoData]()
            for item in photos! {
                var photo = PhotoData()
                if let photoId = item["id"] as? Int {
                    photo.photoId = Int16(photoId)
                }
                if let albumId = item["albumId"] as? Int {
                    photo.albumId = Int16(albumId)
                }
                if let title = item["title"] as? String {
                    photo.title = title
                }
                if let thumbnailUrl = item["thumbnailUrl"] as? String {
                    photo.thumbnailUrl = thumbnailUrl
                }
                result.append(photo)
            }
            return result
        } catch {
            self.status = Status.kNetNoHost
        }
        return nil;
    }

    // Idle function for the template.
    private func _processPictureData(data: NSData) -> NSData {
        return data;
    }
}