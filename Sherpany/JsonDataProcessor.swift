//
//  JsonDataProcessor.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/31/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class JsonDataProcessor: DataProcessorProtocol {
    func processUsers(data: NSData) -> [UserData]? {
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
        }
        return nil;
    }

    func processAlbums(data: NSData) -> [AlbumData]? {
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
        }
        return nil;
    }

    func processPhotos(data: NSData) -> [PhotoData]? {
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
        }
        return nil;
    }

    // Idle function for the template.
    func processPictureData(data: NSData) -> NSData {
        return data;
    }
}