//
//  SwiftyJsonDataProcessor.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 4/19/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import SwiftyJSON


class SwiftyJsonDataProcessor: DataProcessorProtocol {
    private func _jsonArray(data: NSData) -> JSON? {
        let responseJSON = JSON(data: data)
        guard let _ = responseJSON.arrayObject else {
            return nil
        }
        return responseJSON
    }

    func processUsers(data: NSData) -> [UserData]? {
        guard let responseJSON = _jsonArray(data) else {
            print("Invalid users information received from the service")
            return nil
        }
        var result = [UserData]()
        for (_, subJSON):(String, JSON) in responseJSON {
            var userData = UserData()
            if let userId = subJSON["id"].int,
                name = subJSON["name"].string,
                email = subJSON["email"].string,
                catchPhrase = subJSON["company"]["catchPhrase"].string {
                    userData.userId = Int16(userId)
                    userData.name = name
                    userData.email = email
                    userData.catchPhrase = catchPhrase
            } else {
                print("Invalid users information received from the service")
                return nil
            }
            result.append(userData)
        }
        return result
    }

    func processAlbums(data: NSData) -> [AlbumData]? {
        guard let responseJSON = _jsonArray(data) else {
            print("Invalid albums information received from the service")
            return nil
        }
        var result = [AlbumData]()
        for (_, subJSON):(String, JSON) in responseJSON {
            var item = AlbumData()
            if let albumId = subJSON["id"].int,
                userId = subJSON["userId"].int,
                title = subJSON["title"].string {
                    item.albumId = Int16(albumId)
                    item.userId = Int16(userId)
                    item.title = title
            } else {
                print("Invalid albums information received from the service")
                return nil
            }
            result.append(item)
        }
        return result
    }

    func processPhotos(data: NSData) -> [PhotoData]? {
        guard let responseJSON = _jsonArray(data) else {
            print("Invalid photos information received from the service")
            return nil
        }
        var result = [PhotoData]()
        for (_, subJSON):(String, JSON) in responseJSON {
            var item = PhotoData()
            if let photoId = subJSON["id"].int,
                albumId = subJSON["albumId"].int,
                title = subJSON["title"].string,
                thumbnailUrl = subJSON["thumbnailUrl"].string {
                    item.photoId = Int16(photoId)
                    item.albumId = Int16(albumId)
                    item.title = title
                    item.thumbnailUrl = thumbnailUrl
            } else {
                print("Invalid photo information received from the service")
                return nil
            }
            result.append(item)
        }
        return result
    }

    // Idle function for the template.
    func processPictureData(data: NSData) -> NSData {
        return data;
    }
}