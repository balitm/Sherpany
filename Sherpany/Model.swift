//
//  Model.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import DATAStack


enum DataProviderType {
    case Async
    case AsyncSession
    case Alamofire
}

enum DataProcessorType {
    case Json
    case SwiftyJson
    case Xml
}

// Protocol to delegate asynch data processing start and stop events.
protocol ModelNetworkIndicatorDelegate: class {
    func show()
    func hide()
}

protocol DataURLs {
    var kBaseURL: String { get }
    var kUsersPath: String { get }
    var kAlbumsPath: String { get }
    var kPhotosPath: String { get }
}

protocol ModelTypes {
    var kProviderType: DataProviderType { get }
    var kProcessorType: DataProcessorType { get }
}

protocol ConfigProtocol: DataURLs, ModelTypes { }

protocol DataProviderProtocol {
    var indicatorDelegate: ModelNetworkIndicatorDelegate! { get set }
    var dataProcessor: DataProcessorProtocol! { get set }

    func setup(urls: DataURLs)
    func processUsers(finished: (data: [UserData]?) -> Void)
    func processAlbums(finished: (data: [AlbumData]?) -> Void)
    func processPhotos(finished: (data: [PhotoData]?) -> Void)
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
    private var _dataProvider: DataProviderProtocol
    private let _dataStack: DATAStack
    weak var indicatorDelegate: ModelNetworkIndicatorDelegate? = nil {
        didSet {
            _dataProvider.indicatorDelegate = indicatorDelegate
        }
    }


    init(config: ConfigProtocol, dataStack: DATAStack) {
        _dataProvider = DataProviderBase.dataProvider(config)
        _dataProvider.setup(config)
        _dataStack = dataStack
    }

    // Donload user (JSON) data and add it to datatbase.
    func setupUsers(finished: () -> Void) {
//        indicatorDelegate?.show()
        _dataProvider.processUsers { result in
            if let users = result {
                for user in users {
                    self._dataStack.createUserEntity(user)
                }
                self._dataStack.persistWithCompletion(nil)
            } else {
                assert(false, "No users downloaded.")
            }
//            self.indicatorDelegate?.hide()
            finished();
        }
    }

    // Donload albums (JSON) data and add it to datatbase.
    func setupAlbums(finished: () -> Void) {
//        indicatorDelegate?.show()
        _dataProvider.processAlbums { result in
            if let albums = result {
                for album in albums {
                    self._dataStack.createAlbumEntity(album)
                }
                self._dataStack.persistWithCompletion(nil)
            } else {
                assert(false, "No albums downloaded.")
            }
//            self.indicatorDelegate?.hide()
            finished();
        }
    }

    // Donload photos (JSON) data and add it to datatbase.
    func setupPhotos(finished: () -> Void) {
//        indicatorDelegate?.show()
        _dataProvider.processPhotos { result in
            if let photos = result {
                for photo in photos {
                    self._dataStack.createPhotoEntity(photo)
                }
                self._dataStack.persistWithCompletion(nil)
            } else {
                assert(false, "No photos downloaded.")
            }
//            self.indicatorDelegate?.hide()
            finished();
        }
    }

    // Download a thumbnail photo picture from URL of a photo (JSON) data and
    // add it to the database.
    func addPicture(photo: PhotoEntity, finished: () -> Void) {
        guard let url = NSURL(string: photo.thumbnailUrl!) else {
            assert(false)
            return
        }
        _dataProvider.processPicture(url, finished: { (pictureData: NSData?) -> Void in
            if let data = pictureData {
                photo.thumbnail = data
                self._dataStack.persistWithCompletion(nil)
            } else {
                assert(false, "No thubnail downloaded.")
            }
            finished()
            }, progress: { (progress: Float) -> Void in
                print("progress for picture: \(url) is \(progress)")
        })
    }

    // Return if the user database (UserEntity) is empty.
    func isEmptyUsers() -> Bool {
        return _dataStack.isEmpty(UserEntity.entityName)
    }

    // Return if the albums database (AlbumEntity) is empty.
    func isEmptyAlbums() -> Bool {
        return _dataStack.isEmpty(AlbumEntity.entityName)
    }

    // Return if the photos database (PhotoEntity) is empty.
    func isEmptyPhotos() -> Bool {
        return _dataStack.isEmpty(PhotoEntity.entityName)
    }
}