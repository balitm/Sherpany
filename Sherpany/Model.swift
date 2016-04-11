//
//  Model.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation


enum DataProviderType {
    case Async
    case AsyncSession
}

enum DataProcessorType {
    case Json
    case Xml
}

// Protocol to delegate asynch data processing start and stop events.
protocol ModelNetworkIndicatorDelegate: class {
    func show()
    func hide()
}

protocol DataURLs {
    var kUsersURL: NSURL { get }
    var kAlbumsURL: NSURL { get }
    var kPhotosURL: NSURL { get }
}

protocol ModelTypes {
    var kProviderType: DataProviderType { get }
    var kProcessorType: DataProcessorType { get }
}

protocol DataProviderProtocol {
    var dataProcessor: DataProcessorProtocol! { get set }

    func processUsers(url: NSURL, finished: (data: [UserData]?) -> Void)
    func processAlbums(url: NSURL, finished: (data: [AlbumData]?) -> Void)
    func processPhotos(url: NSURL, finished: (data: [PhotoData]?) -> Void)
    func processPicture(url: NSURL, finished: (data: NSData?) -> Void, progress: (Float) -> Void)
    func hasPendingTask() -> Bool
}

protocol DataProcessorProtocol: class {
    func processUsers(data: NSData) -> [UserData]?
    func processAlbums(data: NSData) -> [AlbumData]?
    func processPhotos(data: NSData) -> [PhotoData]?
    func processPictureData(data: NSData) -> NSData
}

// Model class.
class Model {
    // URLs to accessing data for services.
    private let _urls: DataURLs
    private let _dataProvider: DataProviderProtocol
    weak var indicatorDelegate: ModelNetworkIndicatorDelegate? = nil


    init(urls: DataURLs, types: ModelTypes) {
        _urls = urls
        _dataProvider = DataProviderBase.dataProvider(types.kProviderType, processorType: types.kProcessorType, urls: urls)
    }

    private func showIndicator() {
        guard let delegate = indicatorDelegate else {
            return
        }
        if !_dataProvider.hasPendingTask() {
            delegate.show()
        }
    }

    private func hideIndicator() {
        guard let delegate = indicatorDelegate else {
            return
        }
        if !_dataProvider.hasPendingTask() {
            delegate.hide()
        }
    }

    // Donload user (JSON) data and add it to datatbase.
    func setupUsers(finished: () -> Void) {
        indicatorDelegate?.show()
        _dataProvider.processUsers(_urls.kUsersURL, finished: { (result) -> Void in
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
        })
    }

    // Donload albums (JSON) data and add it to datatbase.
    func setupAlbums(finished: () -> Void) {
        indicatorDelegate?.show()
        _dataProvider.processAlbums(_urls.kAlbumsURL, finished: { (result) -> Void in
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
        })
    }

    // Donload photos (JSON) data and add it to datatbase.
    func setupPhotos(finished: () -> Void) {
        indicatorDelegate?.show()
        _dataProvider.processPhotos(_urls.kPhotosURL, finished: { (result) -> Void in
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
        })
    }

    // Download a thumbnail photo picture from URL of a photo (JSON) data and
    // add it to the database.
    func addPicture(photo: PhotoEntity, finished: () -> Void) {
        indicatorDelegate?.show()
        guard let url = NSURL(string: photo.thumbnailUrl!) else {
            assert(false)
            return
        }
        _dataProvider.processPicture(url, finished: { (pictureData: NSData?) -> Void in
            if let data = pictureData {
                let cdm = CoreDataManager.instance
                photo.thumbnail = data
                cdm.saveContext()
            } else {
                assert(false, "No thubnail downloaded.")
            }
            self.indicatorDelegate?.hide()
            finished()
            }, progress: { (progress: Float) -> Void in
                print("progress for picture: \(url) is \(progress)")
        })
    }

    // Return if the user database (UserEntity) is empty.
    func isEmptyUsers() -> Bool {
        return CoreDataManager.instance.isEmpty(UserEntity.entityName)
    }

    // Return if the albums database (AlbumEntity) is empty.
    func isEmptyAlbums() -> Bool {
        return CoreDataManager.instance.isEmpty(AlbumEntity.entityName)
    }

    // Return if the photos database (PhotoEntity) is empty.
    func isEmptyPhotos() -> Bool {
        return CoreDataManager.instance.isEmpty(PhotoEntity.entityName)
    }
}