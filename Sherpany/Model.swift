//
//  Model.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

// Protocol to delegate network start and stop events.
protocol ModelNetworkIndicatorDelegate: class {
    func show()
    func hide()
}

protocol ModelNetworkDownload {
    func downloadUsers(finished: (users: [UserData]?) -> Void)
    func downloadAlbums(finished: (albums: [AlbumData]?) -> Void)
    func downloadPhotos(finished: (photos: [PhotoData]?) -> Void)
    func downloadPicture(url: NSURL, finished: (pictureData: NSData?) -> Void)
}

// Model class.
class Model {
    let net: ModelNetworkDownload
    weak var indicatorDelegate: ModelNetworkIndicatorDelegate? = nil

    init(downloader: ModelNetworkDownload) {
        self.net = downloader
    }

    // Donload user (JSON) data and it to datatbase.
    func setupUsers(finished: () -> Void) {
        indicatorDelegate?.show()
        net.downloadUsers { (result) -> Void in
            if let users = result {
                let cdm = CoreDataManager.instance
                for user in users {
                    cdm.createUserEntity(user)
                }
                cdm.saveContext()
            } else {
                assert(false, "No users downloaded.")
            }
            self.indicatorDelegate?.hide()
            finished();
        }
    }

    // Donload albums (JSON) data and it to datatbase.
    func setupAlbums(finished: () -> Void) {
        indicatorDelegate?.show()
        net.downloadAlbums { (result) -> Void in
            if let albums = result {
                let cdm = CoreDataManager.instance
                for album in albums {
                    cdm.createAlbumEntity(album)
                }
                cdm.saveContext()
            } else {
                assert(false, "No albums downloaded.")
            }
            self.indicatorDelegate?.hide()
            finished();
        }
    }

    // Donload photos (JSON) data and it to datatbase.
    func setupPhotos(finished: () -> Void) {
        indicatorDelegate?.show()
        net.downloadPhotos { (result) -> Void in
            if let photos = result {
                let cdm = CoreDataManager.instance
                for photo in photos {
                    cdm.createPhotoEntity(photo)
                }
                cdm.saveContext()
            } else {
                assert(false, "No photos downloaded.")
            }
            self.indicatorDelegate?.hide()
            finished();
        }
    }

    // Download a thumbnail photo picture from URL of a photo (JSON) data and
    // add it to the database.
    func addPicture(photo: PhotoEntity, finished: () -> Void) {
        indicatorDelegate?.show()
        guard let url = NSURL(string: photo.thumbnailUrl!) else {
            assert(false)
            return
        }
        net.downloadPicture(url, finished: { (pictureData: NSData?) -> Void in
            if let data = pictureData {
                let cdm = CoreDataManager.instance
                photo.thumbnail = data
                cdm.saveContext()
            } else {
                assert(false, "No thubnail downloaded.")
            }
            self.indicatorDelegate?.hide()
            finished()
        })
    }

    // Return if the user database (UserEntity) is empty.
    func isEmptyUsers() -> Bool {
        return CoreDataManager.instance.isEmpty("UserEntity")
    }

    // Return if the albums database (AlbumEntity) is empty.
    func isEmptyAlbums() -> Bool {
        return CoreDataManager.instance.isEmpty("AlbumEntity")
    }

    // Return if the photos database (PhotoEntity) is empty.
    func isEmptyPhotos() -> Bool {
        return CoreDataManager.instance.isEmpty("PhotoEntity")
    }
}