//
//  Model.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

class Model {
    private let _net = ModelNet()

    func setupUsers(finished: () -> Void) {
        do {
            try _net.downloadUsers { (result) -> Void in
                if let users = result {
                    let cdm = CoreDataManager.instance
                    for user in users {
                        cdm.createUserEntity(user)
                    }
                    cdm.saveContext()
                } else {
                    print("No users downloaded.")
                }
                finished();
            }
        } catch {
        }
    }

    func setupAlbums(finished: () -> Void) {
        do {
            try _net.downloadAlbums { (result) -> Void in
                if let albums = result {
                    let cdm = CoreDataManager.instance
                    for album in albums {
                        cdm.createAlbumEntity(album)
                    }
                    cdm.saveContext()
                } else {
                    print("No albums downloaded.")
                }
                finished();
            }
        } catch {
        }
    }

    func setupPhotos(finished: () -> Void) {
        do {
            try _net.downloadPhotos { (result) -> Void in
                if let photos = result {
                    let cdm = CoreDataManager.instance
                    for photo in photos {
                        cdm.createPhotoEntity(photo)
                    }
                    cdm.saveContext()
                } else {
                    print("No photos downloaded.")
                }
                finished();
            }
        } catch {
        }
    }

    func isEmptyAlbums() -> Bool {
        return CoreDataManager.instance.isEmpty("AlbumEntity")
    }

    func isEmptyPhotos() -> Bool {
        return CoreDataManager.instance.isEmpty("PhotoEntity")
    }
}