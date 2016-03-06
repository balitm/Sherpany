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

// Model class.
class Model {
    private let _net = ModelNet()
    weak var indicatorDelegate: ModelNetworkIndicatorDelegate! = nil


    // Donload user (JSON) data and it to datatbase.
    func setupUsers(finished: () -> Void) {
        indicatorDelegate.show()
        do {
            try _net.downloadUsers { (result) -> Void in
                if let users = result {
                    let cdm = CoreDataManager.instance
                    for user in users {
                        cdm.createUserEntity(user)
                    }
                    cdm.saveContext()
                } else {
                    assert(false, "No users downloaded.")
                }
                self.indicatorDelegate.hide()
                finished();
            }
        } catch {
            indicatorDelegate.hide()
            assert(false, "No users downloaded.")
        }
    }

    // Donload albums (JSON) data and it to datatbase.
    func setupAlbums(finished: () -> Void) {
        indicatorDelegate.show()
        do {
            try _net.downloadAlbums { (result) -> Void in
                if let albums = result {
                    let cdm = CoreDataManager.instance
                    for album in albums {
                        cdm.createAlbumEntity(album)
                    }
                    cdm.saveContext()
                } else {
                    assert(false, "No albums downloaded.")
                }
                self.indicatorDelegate.hide()
                finished();
            }
        } catch {
            indicatorDelegate.hide()
            assert(false, "No albums downloaded.")
        }
    }

    // Donload photos (JSON) data and it to datatbase.
    func setupPhotos(finished: () -> Void) {
        indicatorDelegate.show()
        do {
            try _net.downloadPhotos { (result) -> Void in
                if let photos = result {
                    let cdm = CoreDataManager.instance
                    for photo in photos {
                        cdm.createPhotoEntity(photo)
                    }
                    cdm.saveContext()
                } else {
                    assert(false, "No photos downloaded.")
                }
                self.indicatorDelegate.hide()
                finished();
            }
        } catch {
            indicatorDelegate.hide()
            assert(false, "No photos downloaded.")
        }
    }

    // Download a thumbnail photo picture from URL of a photo (JSON) data and
    // add it to the database.
    func addPicture(photo: PhotoEntity, finished: () -> Void) {
        do {
            indicatorDelegate.show()
            try _net.downloadPicture(photo.thumbnailUrl!, finished: { (pictureData: NSData?) -> Void in
                if let data = pictureData {
                    let cdm = CoreDataManager.instance
                    photo.thumbnail = data
                    cdm.saveContext()
                } else {
                    assert(false, "No thubnail downloaded.")
                }
                self.indicatorDelegate.hide()
                finished()
            })
        } catch {
            indicatorDelegate.hide()
            assert(false, "No thubnail downloaded.")
        }
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